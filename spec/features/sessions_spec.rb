require 'rails_helper'

feature 'Sessions' do
  before :each do
    @user = FactoryBot.create(:user)
  end

  scenario 'User can login with Auth0' do
    visit login_path

    expect(page).to have_content 'Chester Butkiewicz'
  end
end