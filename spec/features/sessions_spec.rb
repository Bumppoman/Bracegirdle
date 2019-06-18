require 'rails_helper'

feature 'Sessions' do
  before :each do
    @user = FactoryBot.create(:user)
  end

  scenario 'User can login with Auth0' do
    visit login_path

    expect(page).to have_content 'Chester Butkiewicz'
  end

  scenario 'User has failed login with Auth0' do
    visit auth_failure_path

    expect(page.status_code).to be 200
  end

  scenario 'User can log out with Auth0' do
    class DummyController < ApplicationController
      def dummy
        render inline: 'Hello world'
      end
    end
    Rails.application.routes.append do
      get '/v2/logout', to: 'dummy#dummy'
    end
    Rails.application.reload_routes!

    visit login_path

    expect { visit new_complaint_path }.not_to raise_error

    visit logout_path

    expect { visit new_complaint_path }.to raise_error(ApplicationController::Forbidden)
  end
end