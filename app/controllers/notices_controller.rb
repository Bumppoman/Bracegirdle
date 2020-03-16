class NoticesController < ApplicationController
  def create
    # Create the object
    @notice = authorize Notice.new(notice_params)

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
    @notice = authorize Notice.find(params[:id])

    send_data PDFGenerators::NoticePDFGenerator.call(@notice).render,
              filename: "#{@notice.notice_number}.pdf",
              type: 'application/pdf',
              disposition: 'inline'
  end

  def follow_up
    @notice = authorize Notice.find(params[:id])

    @notice.update(
      **notice_date_params,
      status: :follow_up_completed)
    Notices::NoticeFollowUpEvent.new(@notice, current_user).trigger

    respond_to do |m|
      m.js { render partial: 'notices/update/follow_up'}
    end
  end

  def index
    @notices = authorize current_user.notices.includes(:cemetery)
  end

  def new
    @notice = authorize Notice.new(served_on_state: 'NY')
  end

  def resolve
    @notice = authorize Notice.find(params[:id])

    @notice.update(
      notice_resolved_date: Date.current,
      status: :resolved
    )
    Notices::NoticeResolvedEvent.new(@notice, current_user).trigger

    respond_to do |m|
      m.js { render partial: 'notices/update/resolve'}
    end
  end

  def response_received
    @notice = authorize Notice.find(params[:id])

    @notice.update(
      response_received_date: Date.current,
      status: :response_received)
    Notices::NoticeResponseEvent.new(@notice, current_user).trigger

    respond_to do |m|
      m.js { render partial: 'notices/update/response_received'}
    end
  end

  def show
    @notice = authorize Notice.includes(notes: :user).find(params[:id])
  end

  private

  def notice_params
    params.require(:notice).permit(:served_on_name, :served_on_title, :served_on_street_address, :served_on_city, :served_on_state, :served_on_zip, :law_sections, :specific_information)
  end

  def notice_date_params
    date_params %w(response_required_date violation_date follow_up_inspection_date), params[:notice]
  end
end
