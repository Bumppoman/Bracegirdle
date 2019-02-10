class NoticesController < ApplicationController
  include Permissions

  before_action do
    stipulate :must_be_investigator
  end

  def create
    # Create the object
    @notice = Notice.new(notice_params)

    # Set the cemetery and investigator
    begin
      @notice.cemetery = Cemetery.find(params.dig(:notice, :cemetery))
    rescue ActiveRecord::RecordNotFound
      @notice.cemetery = nil
    end

    @notice.investigator = current_user

    # Update dates
    @notice.update(notice_date_params)

    if @notice.save
      redirect_to notice_path(@notice, prompt: true) and return
    else
      # Render the form again if the notice didn't save
      @title = 'Issue New Notice of Non-Compliance'
      @breadcrumbs = { 'Issue new Notice of Non-Compliance' => nil }
      @notice.cemetery_county = params[:notice][:cemetery_county]

      render action: :new
    end
  end

  def download
    # Get notice
    @notice = Notice.find(params[:id])

    # Create Word document notice
    all_params = @notice.attributes.merge(
      cemetery_name: @notice.cemetery.name,
      cemetery_number: @notice.cemetery.cemetery_id,
      investigator_name: @notice.investigator.name,
      investigator_title: @notice.investigator.title,
      response_street_address: @notice.investigator.street_address,
      response_city: @notice.investigator.city,
      response_zip: @notice.investigator.zip,
      notice_date: @notice.created_at,
      secondary_law_sections: @notice.law_sections,
      'served_on_title' => POSITIONS[@notice.served_on_title.to_i]
    )
    word_notice = helpers.update_docx('lib/document_templates/non-compliance.docx', all_params)

    send_data word_notice,
              type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document; charset=UTF-8;',
              disposition: "attachment; filename=#{@notice.notice_number}.docx"
  end

  def edit
    @title = 'Update Notice of Non-Compliance'
  end

  def index
    @notices = Notice.active.where(investigator: current_user)

    @title = 'My Active Notices of Non-Compliance'
    @breadcrumbs = { 'My Active Notices of Non-Compliance' => nil }
  end

  def new
    @notice = Notice.new
    @notice.served_on_state = 'NY'

    @title = 'Issue New Notice of Non-Compliance'
    @breadcrumbs = { 'Issue new Notice of Non-Compliance' => nil }
  end

  def show
    @notice = Notice.includes(notes: :user).find(params[:id])

    @title = "Notice of Non-Compliance ##{@notice.notice_number}"
    @breadcrumbs = { 'My active notices' => notices_path, @title => nil }
  end

  def update_status
    @notice = Notice.find(params[:id])

    response_received if params.key? :response_received
    follow_up_date if params.key? :follow_up_date
    follow_up_completed if params.key? :follow_up_completed
    resolve_notice if params.key? :resolve_notice

    # Respond
    if @notice.save
      respond_to do |m|
        m.js { render partial: @response }
      end
    end
  end

  private

  def follow_up_completed
    @notice.follow_up_inspection_date = helpers.format_date_param(params[:notice][:follow_up_inspection_date])
    @notice.status = 3
    @response = 'notices/update/follow_up_complete'
  end

  def follow_up_date
    @response = 'notices/update/follow_up_date'
  end

  def notice_params
    params.require(:notice).permit(:served_on_name, :served_on_title, :served_on_street_address, :served_on_city, :served_on_state, :served_on_zip, :law_sections, :specific_information)
  end

  def notice_date_params
    date_params = {}
    %i[response_required_date violation_date].each do |param|
      date_params[param] = helpers.format_date_param(params[:notice][param])
    end

    date_params
  end

  def resolve_notice
    @notice.notice_resolved_date = Date.current
    @notice.status = 4
    @response = 'notices/update/resolve_notice'
  end

  def response_received
    @notice.response_received_date = Date.current
    @notice.status = 2
    @response = 'notices/update/response_received'
  end
end
