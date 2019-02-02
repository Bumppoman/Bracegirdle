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
    session[:user_id] = nil
    redirect_to root_url, notice: 'Signed out!'
  end

  def new
    @title = 'Sign In'
    @breadcrumbs = false
  end
end
