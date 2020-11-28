class NoticesController < ApplicationController
  def create
    # Create the object
    @notice = authorize Notice.new(notice_params)

    # Set the cemetery, investigator, and trustee
    @notice.update(
      cemetery_cemid: params[:notice][:cemetery],
      trustee_id: params[:notice][:trustee]
    )
    @notice.investigator = current_user

    if @notice.save
      Notices::NoticeIssueEvent.new(@notice, current_user).trigger
      redirect_to notice_path(@notice, download_notice: true) and return
    else
      @notice.cemetery_county = params[:notice][:cemetery_county]
      render action: :new
    end
  end

  def download
    @notice = authorize Notice.find(params[:id])

    send_data PDFGenerators::NoticePDFGenerator.call(@notice).render,
      filename: "#{@notice.notice_number}.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end

  def follow_up
    @notice = authorize Notice.find(params[:id])

    @notice.update(
      follow_up_completed_date: params[:notice][:follow_up_completed_date],
      status: :follow_up_completed
    )
    Notices::NoticeFollowUpEvent.new(@notice, current_user).trigger

    respond_to :js
  end

  def index
    @notices = authorize current_user.notices.includes(:cemetery)
  end

  def new
    @notice = authorize Notice.new(
      response_required_date: (Date.current + 2.weeks).next_occurring(:monday),
      served_on_state: 'NY',
      violation_date: Date.current
    )
  end
  
  def receive_response
    @notice = authorize Notice.find(params[:id])

    @notice.update(
      response_received_date: Date.current,
      status: :response_received
    )
    Notices::NoticeResponseEvent.new(@notice, current_user).trigger

    respond_to :js
  end

  def resolve
    @notice = authorize Notice.find(params[:id])

    @notice.update(
      resolved_date: Date.current,
      status: :resolved
    )
    Notices::NoticeResolvedEvent.new(@notice, current_user).trigger

    respond_to :js
  end

  def show
    @notice = authorize Notice.includes(:cemetery, :investigator, :trustee, attachments: [file_attachment: :blob], notes: :user)
      .find(params[:id])
  end

  private

  def notice_params
    params.require(:notice).permit(
      :served_on_street_address, :served_on_city, :served_on_state, :served_on_zip, 
      :law_sections, :specific_information, :response_required_date, :violation_date)
  end
end
