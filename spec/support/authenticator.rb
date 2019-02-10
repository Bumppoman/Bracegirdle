module Authenticator
  def create_default_user
    @user = FactoryBot.create(:user)
  end

  def login(user = nil)
    user ||= create_default_user

    visit root_path
    fill_in 'email[]', with: user.email
    fill_in 'password[]', with: 'pa$$word'
    click_button 'Sign In'
  end

  def login_supervisor
    login(FactoryBot.create(:supervisor))
  end
end

RSpec.configure do |config|
  config.include Authenticator, type: :feature
end