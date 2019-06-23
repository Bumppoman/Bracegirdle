class AppointmentsController < ApplicationController
  include Permissions

  before_action do
    stipulate :must_be_investigator
  end

  def api_user_events
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

  def begin
    @appointment = Appointment.find(params[:id])
    @appointment.update(status: :completed)

    # Set the item to begin
    if current_user.investigator?
      @path = inspect_cemetery_path(@appointment.cemetery)
    end

    respond_to do |m|
      m.js
    end
  end

  def cancel
    @appointment = Appointment.find(params[:id])
    @appointment.update(status: :cancelled)

    respond_to do |m|
      m.js
    end
  end

  def create
    date = parse_date
    @appointment = Appointment.create(
      cemetery: Cemetery.find(params[:appointment][:cemetery]),
      user: current_user,
      begin: date,
      end: date + 90.minutes,
      status: :scheduled)

    redirect_to appointments_path
  end

  def index
    @appointments = current_user.appointments.where(status: :scheduled).order(:begin)
    @appointment_name = current_user.investigator? ? 'inspection' : 'audit'
  end

  def reschedule
    @appointment = Appointment.find(params[:id])
    date = parse_date
    @appointment.update(
      begin: date,
      end: date + 90.minutes)

    respond_to do |m|
      m.js
    end
  end

  private

  def parse_date
    Time.strptime("#{params[:appointment][:date]} #{params[:appointment][:time]}", '%m/%d/%Y %I:%M %p')
  end
end
