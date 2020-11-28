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

module RequestAuthenticator
  def create_default_user
    @user = FactoryBot.create(:user)
  end

  def login(user = nil)
    user ||= create_default_user

    data = ::RackSessionAccess.encode({ user_id: user.id, userinfo: { 'uid' => '1test1' } })
    put ::RackSessionAccess.path, params: { data: data }
  end
end

RSpec.configure do |config|
  config.include Authenticator, type: :feature
  config.include RequestAuthenticator, type: :request
end
