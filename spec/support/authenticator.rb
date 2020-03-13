module Authenticator
  def create_default_user
    @user = FactoryBot.create(:user)
  end

  def login(user = nil)
    user ||= create_default_user

    page.set_rack_session(user_id: user.id, userinfo: { 'uid' => '1test1' })
    visit root_path
  end

  def login_supervisor
    login(FactoryBot.create(:supervisor))
  end

  def logout
    page.set_rack_session(user_id: nil)
  end
end

RSpec.configure do |config|
  config.include Authenticator, type: :feature
end
