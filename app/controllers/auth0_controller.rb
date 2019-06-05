class Auth0Controller < ApplicationController
  def callback
    userinfo = request.env['omniauth.auth']
    if user = User.find_by_email(userinfo['info']['email'])
      session[:user_id] = user.id
      redirect_to '/'
    else
      raise
    end
  end

  def failure
    @error_msg = request.params['message']
  end
end
