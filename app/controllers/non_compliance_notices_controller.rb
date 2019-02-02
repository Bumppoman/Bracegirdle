class NonComplianceNoticesController < ApplicationController
  def create
    # Create the object
    @notice = NonComplianceNotice.new(non_compliance_notice_params)

    # Set the cemetery and investigator
    begin
      @notice.cemetery = Cemetery.find(params.dig(:non_compliance_notice, :cemetery))
    rescue ActiveRecord::RecordNotFound
      @notice.cemetery = nil
    end

    @notice.investigator = current_user

    # Update dates
    @notice.update(non_compliance_notice_date_params)

    if @notice.save
      redirect_to non_compliance_notice_path(@notice, prompt: true) and return
    else
      # Render the form again if the notice didn't save
      @title = 'Issue New Notice of Non-Compliance'
      @breadcrumbs = { 'Issue new Notice of Non-Compliance' => nil }
      @notice.cemetery_county = params[:non_compliance_notice][:cemetery_county]

      render action: :new
    end
  end

  def download
    # Get notice
    @notice = NonComplianceNotice.find(params[:id])

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
    @notices = NonComplianceNotice.where(investigator: current_user)

    @title = 'My Active Notices of Non-Compliance'
    @breadcrumbs = { 'My Active Notices of Non-Compliance' => nil }
  end

  def new
    @notice = NonComplianceNotice.new
    @notice.served_on_state = 'NY'

    @title = 'Issue New Notice of Non-Compliance'
    @breadcrumbs = { 'Issue new Notice of Non-Compliance' => nil }
  end

  def show
    @notice = NonComplianceNotice.includes(notes: :user).find(params[:id])

    @title = "Notice of Non-Compliance ##{@notice.notice_number}"
    @breadcrumbs = { 'My active notices' => non_compliance_notices_path, @title => nil }
  end

  def update_status
    @notice = NonComplianceNotice.find(params[:id])

    response_received if params.key? :response_received

    # Respond
    respond_to do |m|
      m.js { render partial: @response }
    end
  end

  private

  def non_compliance_notice_params
    params.require(:non_compliance_notice).permit(:served_on_name, :served_on_title, :served_on_street_address, :served_on_city, :served_on_state, :served_on_zip, :law_sections, :specific_information)
  end

  def non_compliance_notice_date_params
    date_params = {}
    %i[response_required_date violation_date].each do |param|
      date_params[param] = helpers.format_date_param(params[:non_compliance_notice][param])
    end

    date_params
  end

  def response_received
    @notice.response_received_date = Time.zone.today
    @response = 'non_compliance_notices/update/response_received'
  end
end
