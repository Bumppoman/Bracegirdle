# frozen_string_literal: true

class UsersController < ApplicationController
  def calendar
  end
  
  def calendar_events

    # Get appointments
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
    
    # Add board meetings
    @board_meetings = BoardMeeting.all
    response += @board_meetings.map do |meeting|
      {
        title: "#{meeting.date.strftime('%B %Y')} Board Meeting",
        id: meeting.id.to_s,
        start: meeting.date.strftime('%Y-%m-%d %H:%M:%S'),
        end: (meeting.date + 3.hours).strftime('%Y-%m-%d %H:%M:%S')
      }
    end

    respond_to do |format|
      format.json { render json: response.to_json }
    end
  end

  def change_password
  end

  def profile
    @user = User.find_by(id: params[:id]) || current_user
    @recent_complaints = @user.complaints.order(created_at: :desc).limit(5)
  end

  def team
    @team = if params.key?(:team)
      params[:team]
    elsif current_user.team.nil?
      current_user.id
    else
      current_user.team
    end

    @members = User.team(@team)
    @complaints = Complaint.active.team(@team).includes(:cemetery)
  end

  def update_password
    # Make sure the passwords match
    unless params[:user][:new_password] == params[:user][:confirm_new_password]
      @errors = ['Both passwords must match']
      render :change_password and return
    end

    token = get_token

    url = URI("https://bracegirdle.auth0.com/api/v2/users/#{session[:userinfo]['uid']}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    request = Net::HTTP::Patch.new(url)
    request['content-type'] = 'application/json'
    request['authorization'] = "Bearer #{token['access_token']}"
    request.body = {
        password: params[:user][:new_password],
        connection: 'Username-Password-Authentication' }.to_json

    response = JSON.parse(http.request(request).read_body)

    if response.key? 'email'
      redirect_to :logout
    else
      @errors = [response['message'].split(': ')[1]]
      render :change_password
    end
  end
end
