class BoardMeetingsController < ApplicationController
  def download_agenda
    @board_meeting = authorize BoardMeeting.find(params[:id])

    pdf = AgendaPdf.new(@board_meeting)

    send_data pdf.render,
      filename: "Agenda-#{@board_meeting.date.strftime('%F')}.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end

  def finalize_agenda
    @board_meeting = authorize BoardMeeting.find(params[:id])
    @board_meeting.update(status: :agenda_finalized)

    # Set identifiers for matters
    @board_meeting.set_matter_identifiers

    redirect_to @board_meeting
  end

  def index
    @board_meetings = authorize BoardMeeting.all.order(date: :asc)
  end

  def show
    @board_meeting = authorize BoardMeeting.find(params[:id])
  end
end
