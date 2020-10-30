class MattersController < ApplicationController
  def schedulable
    @matters = Matter.includes(:board_application).unscheduled
    @board_meetings = BoardMeeting.all.order(:date)
  end
  
  def schedule
    @matter = Matter.find(params[:id])
    @matter.update(
      board_meeting: BoardMeeting.find(params[:matter][:board_meeting]),
      status: :scheduled
    )

    # Update application status as well
    @matter.board_application.update(
      status: :scheduled
    )

    Matters::MatterScheduledEvent.new(@matter, current_user).trigger
  end

  def unschedule
    @matter = Matter.find(params[:id])
    @matter.update(
      board_meeting: nil,
      status: :unscheduled
    )

    # Update application status as well
    @matter.board_application.update(
      status: :reviewed
    )

    Matters::MatterUnscheduledEvent.new(@matter, current_user).trigger
  end
end
