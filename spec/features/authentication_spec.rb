require 'rails_helper'

feature 'User authentication' do
  scenario 'Can log in' do
    login

    expect(page).to have_content('Chester Butkiewicz')
  end

  scenario 'Can log out' do
    login

    visit root_path
    click_on 'Sign Out'

    expect(page).to have_content('Sign In')
  end
end