class BoardMeetingsController < ApplicationController
  def create
    @board_meeting = authorize BoardMeeting.new(board_meeting_params)
    @board_meeting.date = Time.parse("#{params[:board_meeting][:raw_date]} #{params[:board_meeting][:raw_time]}")
    @board_meeting.save
    
    redirect_to @board_meeting
  end
  
  def download_agenda
    @board_meeting = authorize BoardMeeting.find(params[:id])

    pdf = AgendaPDF.new(@board_meeting)

    send_data pdf.render,
      filename: "Agenda-#{@board_meeting.date.strftime('%F')}.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end
  
  def download_board_orders
    @board_meeting = authorize BoardMeeting.includes(matters: [board_application: :cemetery]).find(params[:id])

    send_data PDFGenerators::BoardOrdersPDFGenerator.call(@board_meeting).to_pdf,
      filename: "Agenda-#{@board_meeting.date.strftime('%F')}.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end

  def finalize_agenda
    @board_meeting = authorize BoardMeeting.find(params[:id])
    @board_meeting.update(status: :agenda_finalized)

    # Set identifiers for matters
    @board_meeting.set_matter_identifiers

    redirect_to @board_meeting, flash: {
      success: 'You have successfully finalized the agenda for this meeting.'
    }
  end

  def index
    @board_meetings = authorize BoardMeeting.all.order(:date)
  end

  def show
    @board_meeting = authorize BoardMeeting.find(params[:id])
  end
  
  private
  
  def board_meeting_params
    params.require(:board_meeting).permit(:location)
  end
end
