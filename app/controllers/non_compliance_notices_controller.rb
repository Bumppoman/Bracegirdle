class NonComplianceNoticesController < ApplicationController

  def create

    # Create the object
    @notice = NonComplianceNotice.new(non_compliance_notice_params)

    # Set the cemetery and investigator
    @notice.cemetery = Cemetery.find(params[:non_compliance_notice][:cemetery]) rescue nil
    @notice.investigator = current_user

    # Update dates
    @notice.update(non_compliance_notice_date_params)

    # Save the data
    if @notice.save

      # Set the notice number
      @notice.notice_number = "#{@notice.investigator.office_code}-#{Date.today.year}-#{@notice.id}"
      @notice.save

      redirect_to non_compliance_notice_path(@notice, prompt: true)
    else
      @title = 'Issue New Notice of Non-Compliance'
      @breadcrumbs = { 'Issue new Notice of Non-Compliance' => nil }

      render action: :new
    end
  end

  def download
    # Get notice
    @notice = NonComplianceNotice.find(params[:id])

    # Create Word document notice
    all_params = @notice.attributes.merge({ cemetery_name: @notice.cemetery.name, cemetery_number: @notice.cemetery.cemetery_id, investigator_name: @notice.investigator.name, investigator_title: @notice.investigator.title, 'served_on_title' => POSITIONS[@notice.served_on_title.to_i] })
    word_notice = helpers.update_docx('tmp/test.docx', all_params)

    send_data word_notice,
              :type => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document; charset=UTF-8;',
              :disposition => "attachment; filename=#{@notice.notice_number}.docx"
  end

  def edit
    @title = "Update Notice of Non-Compliance"
  end

  def index
    @notices = NonComplianceNotice.where(investigator: current_user)

    @title = "My Active Notices of Non-Compliance"
    @breadcrumbs = { "My active Notices of Non-Compliance" => nil }
  end

  def new
    @notice = NonComplianceNotice.new
    @notice.served_on_state = "NY"

    @title = "Issue New Notice of Non-Compliance"
    @breadcrumbs = { 'Issue new Notice of Non-Compliance' => nil }
  end

  def show
    # Get notice
    @notice = NonComplianceNotice.find(params[:id])
  end

  private
    def non_compliance_notice_params
      params.require(:non_compliance_notice).permit(:served_on_name, :served_on_title, :served_on_street_address, :served_on_city, :served_on_state, :served_on_zip, :law_sections, :specific_information)
    end

    def non_compliance_notice_date_params
      date_params = {}
      [:response_required_date, :violation_date].each do |param|
        if params[:non_compliance_notice][param] =~ /[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}/
          date_params[param] = Date.strptime(params[:non_compliance_notice][param], "%m/%d/%Y", )
        else
          date_params[param] = Date.parse(params[:non_compliance_notice][param]) rescue nil
        end
      end

      date_params
    end
end
