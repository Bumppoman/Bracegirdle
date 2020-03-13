class MattersController < ApplicationController
  def schedule
    @matter = Matter.find(params[:id])
    @matter.update(
      board_meeting: BoardMeeting.find(params[:matter][:board_meeting]),
      status: :scheduled
    )

    # Update application status as well
    @matter.application.update(
      status: :scheduled
    )

    Matters::MatterScheduledEvent.new(@matter, current_user).trigger

    respond_to do |m|
      m.js
    end
  end

  def unschedule
    @matter = Matter.find(params[:id])
    @matter.update(
      board_meeting: nil,
      status: :unscheduled
    )

    # Update application status as well
    @matter.application.update(
      status: :reviewed
    )

    Matters::MatterUnscheduledEvent.new(@matter, current_user).trigger


    #respond_to do |m|
      #m.js
    #end
  end
end
