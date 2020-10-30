class AppointmentsController < ApplicationController
  def begin
    @appointment = authorize Appointment.find(params[:id])
    @appointment.update(status: :completed)

    # Set the item to begin
    if current_user.investigator?
      BeginCemeteryInspection.call(@appointment.cemetery, current_user)
      @path = inspect_cemetery_path(@appointment.cemetery)
    end

    redirect_to @path
  end

  def cancel
    @appointment = authorize Appointment.find(params[:id])
    @appointment_name = appointment_name
    @appointment.update(status: :cancelled)

    respond_to :js
  end

  def create
    date = parse_date
    @appointment = authorize Appointment.create(
      cemetery: Cemetery.find(params[:appointment][:cemetery]),
      user: current_user,
      begin: date,
      end: date + 90.minutes,
      status: :scheduled
    )

    redirect_to appointments_path
  end

  def index
    @appointments = authorize current_user.appointments.where(status: :scheduled).order(:begin)
    @appointment_name = appointment_name
  end
  
  def index_for_calendar
    @events = current_user.appointments
      .where(begin: Time.parse(params[:start])..Time.parse(params[:end]))
      .where.not(status: :cancelled)

    response = @events.map do |event|
      {
        title: event.cemetery.name,
        id: event.id.to_s,
        start: event.begin.strftime('%Y-%m-%d %H:%M:%S'),
        end: event.end.strftime('%Y-%m-%d %H:%M:%S')
      }
    end

    respond_to do |format|
      format.json { render json: response.to_json }
    end
  end

  def reschedule
    @appointment = authorize Appointment.find(params[:id])
    date = parse_date
    @appointment.update(
      begin: date,
      end: date + 90.minutes
    )

    respond_to :js
  end

  private
  
  def appointment_name
    current_user.investigator? ? 'inspection' : 'audit'
  end

  def parse_date
    Time.strptime("#{params[:appointment][:date]} #{params[:appointment][:time]}", '%Y-%m-%d %H:%M')
  end
end
