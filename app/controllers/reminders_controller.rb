class RemindersController < ApplicationController
  def complete
    @reminder = Reminder.find(params[:id])
    @reminder.update(completed: true)
  end
  
  def destroy
    @reminder = Reminder.find(params[:id])
  end
  
  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.due_date = Time.zone.parse("#{params[:reminder][:due_date]} #{params[:reminder][:due_time]}")
    @reminder.user = current_user
    @reminder.save
  end
  
  private
  
  def reminder_params
    params.require(:reminder).permit(:title, :body)
  end
end
