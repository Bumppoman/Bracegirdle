require 'rails_helper'

feature 'Users' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
  end

  scenario 'User can display the calendar', js: true do
    login
    @appointment = FactoryBot.create(:appointment)
    @board_meeting = FactoryBot.create(:board_meeting, date: Date.current)

    visit calendar_user_path

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'User can display the profile', js: true do
    login

    visit user_profile_path

    expect(page).to have_content 'Chester Butkiewicz'
  end

  scenario 'Investigator can view team' do
    supervisor = FactoryBot.create(:mean_supervisor)
    user = FactoryBot.create(:user, team: 1)
    login(user)

    visit team_users_path

    expect(page).to have_content 'Chester Butkiewicz'
  end

  scenario 'Supervisor can view team' do
    user = FactoryBot.create(:user, team: 2)
    login_supervisor

    visit team_users_path

    expect(page).to have_content 'Chester Butkiewicz'
  end

  scenario "Supervisor can view another user's team" do
    user = FactoryBot.create(:user, team: 3)
    login_supervisor
    other_user = FactoryBot.create(:mean_supervisor)

    visit team_users_path(3)

    expect(page).to have_content 'Chester Butkiewicz'
  end

  scenario 'User can change password' do
    class DummyController < ApplicationController
      skip_before_action :ensure_authenticated
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
