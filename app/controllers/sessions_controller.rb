require 'uri'
require 'net/http'

class SessionsController < ApplicationController
  skip_before_action :ensure_authenticated

  def callback
    session[:userinfo] = request.env['omniauth.auth']
    if user = User.find_by_email(session[:userinfo].info['name'])
      session[:user_id] = user.id
      redirect_to root_path
    end
  end

  def create
    redirect_to '/auth/auth0'
  end

  def destroy
    reset_session

    domain = Rails.application.credentials.auth0[:domain]
    client_id = Rails.application.credentials.auth0[:client_id]
    request_params = {
        returnTo: root_url,
        client_id: client_id
    }

    redirect_to URI::HTTPS.build(host: domain, path: '/v2/logout', query: request_params.to_query).to_s
  end

  def failure
    @error_msg = request.params['message']
  end
end
