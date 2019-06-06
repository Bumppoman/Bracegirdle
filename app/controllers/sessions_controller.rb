class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password][0])
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Signed in!'
    else
      flash.now[:alert] = 'Your email or password is invalid.'
      @title = 'Sign In'
      @breadcrumbs = false
      render :new
    end
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
    #redirect_to root_url, notice: 'Signed out!'
  end

  def new
    redirect_to '/auth/auth0'
    #@title = 'Sign In'
    #@breadcrumbs = false
  end
end
