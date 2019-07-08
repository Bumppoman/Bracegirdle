require 'rails_helper'

feature 'Users' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
  end

  scenario 'User can display the calendar', js: true do
    login
    @appointment = FactoryBot.create(:appointment)

    visit user_calendar_path

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'User can display the profile', js: true do
    login

    visit user_profile_path

    expect(page).to have_content 'Chester Butkiewicz'
  end

  scenario 'User can change password' do
    class DummyController < ApplicationController
      def dummy
        render inline: 'Hello world'
      end
    end
    Rails.application.routes.append do
      get '/v2/logout', to: 'dummy#dummy'
    end
    Rails.application.reload_routes!
    stub_request(:post, /bracegirdle.auth0.com\/oauth/).
        with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(status: 200, body: { token: 'test' }.to_json, headers: {})
    stub_request(:patch, /bracegirdle.auth0.com\/api/).
        with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(status: 200, body: { email: 'test' }.to_json, headers: {})
    login

    visit change_user_password_path
    fill_in 'user[new_password]', with: 'Testing123'
    fill_in 'user[confirm_new_password]', with: 'Testing123'
    click_on 'Change password'
  end

  scenario 'New passwords do not match' do
    stub_request(:post, /bracegirdle.auth0.com\/oauth/).
        with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(status: 200, body: { token: 'test' }.to_json, headers: {})
    stub_request(:patch, /bracegirdle.auth0.com\/api/).
        with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(status: 200, body: { email: 'test' }.to_json, headers: {})
    login

    visit change_user_password_path
    fill_in 'user[new_password]', with: 'Testing1234'
    fill_in 'user[confirm_new_password]', with: 'Testing123'
    click_on 'Change password'

    expect(page).to have_content('There was a problem changing your password!')
  end

  scenario 'User has a weak new password' do
    stub_request(:post, /bracegirdle.auth0.com\/oauth/).
        with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(status: 200, body: { token: 'test' }.to_json, headers: {})
    stub_request(:patch, /bracegirdle.auth0.com\/api/).
        with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(status: 200, body: { message: 'TestError: ERROR' }.to_json, headers: {})
    login

    visit change_user_password_path
    fill_in 'user[new_password]', with: 'Testing123'
    fill_in 'user[confirm_new_password]', with: 'Testing123'
    click_on 'Change password'

    expect(page).to have_content('There was a problem changing your password!')
  end
end
