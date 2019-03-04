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
    @notice.assign_attributes(notice_date_params)

    if @notice.save
      Notices::NoticeIssueEvent.new(@notice, current_user).trigger
      redirect_to notice_path(@notice, download_notice: true) and return
    else
      @notice.cemetery_county = params[:notice][:cemetery_county]
      render action: :new
    end
  end

  def download
    @notice = Notice.find(params[:id])
    pdf = NoticePDF.new(
        @notice.attributes.merge(
            'cemetery_name' => @notice.cemetery.name,
            'cemetery_number' => @notice.cemetery.cemetery_id,
            'investigator_name' => @notice.investigator.name,
            'investigator_title' => @notice.investigator.title,
            'response_street_address' => @notice.investigator.street_address,
            'response_city' => @notice.investigator.city,
            'response_zip' => @notice.investigator.zip,
            'notice_date' => @notice.created_at,
            'secondary_law_sections' => @notice.law_sections,
            'served_on_title' => POSITIONS[@notice.served_on_title.to_i]
        )
    )
    send_data pdf.render,
              filename: "#{@notice.notice_number}.pdf",
              type: 'application/pdf',
              disposition: 'inline'
  end

  def edit; end

  def index
    @notices = Notice.includes(:cemetery).active.where(investigator: current_user)
  end

  def new
    @notice = Notice.new(served_on_state: 'NY')
  end

  def show
    @notice = Notice.includes(notes: :user).find(params[:id])
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
    @notice.update(notice_date_params)
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
    date_params %w(response_required_date violation_date follow_up_inspection_date), params[:notice]
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
    Notices::NoticeResponseEvent.new(@notice, current_user).trigger
  end
end
