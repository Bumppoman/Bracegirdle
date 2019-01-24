module SessionsHelper
  def current_user
    @current_user ||= User.find(1)
  end
end
