class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent
  include Pundit, SessionsHelper

  before_action :ensure_authenticated
  
  def ensure_authenticated
    redirect_to :splash and return unless current_user
  end
end