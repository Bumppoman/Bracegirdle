require 'uri'
require 'net/http'

class Auth0Controller < ApplicationController
  def callback
    session[:userinfo] = request.env['omniauth.auth']
    if user = User.find_by_email(session[:userinfo].info['name'])
      session[:user_id] = user.id
      redirect_to root_path
    end
  end

  def failure
    @error_msg = request.params['message']
  end
end
