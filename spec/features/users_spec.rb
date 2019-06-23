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
end
