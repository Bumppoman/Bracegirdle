require 'rails_helper'

feature 'Matters' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
    @contractor = FactoryBot.create(:contractor)
    @board_application = FactoryBot.create(:reviewed_hazardous)
    @board_meeting = FactoryBot.create(:board_meeting, date: '2028-03-01')
    @matter = FactoryBot.create(:matter, board_application: @board_application)
  end
  
  scenario 'Pending applications shows eligible applications' do
    @reviewed = FactoryBot.create(:reviewed_hazardous)
    @matter = FactoryBot.create(:matter, board_application: @reviewed)
    login

    visit schedulable_matters_path

    expect(page).to have_content "HAZD-#{Date.today.year}-00001"
  end

  scenario 'Matters can be scheduled for a board meeting', js: true do
    login

    visit schedulable_matters_path
    click_button 'Schedule'
    choose 'matter_board_meeting_1'
    click_button 'Schedule Matter'
    assert_selector '.disappearing-success-message'
    visit board_meetings_path
    click_link 'March 2028'

    expect(page).to have_content 'Anthony Cemetery (#04-001) – Hazardous'
  end

  scenario 'Scheduled matters can be unscheduled', js: true do
    login
    visit schedulable_matters_path
    click_button 'Schedule'
    choose 'matter_board_meeting_1'
    click_button 'Schedule Matter'
    assert_selector '.disappearing-success-message'
    visit board_meetings_path
    click_link 'March 2028'

    click_button 'Unschedule'
    within '#bracegirdle-confirmation-modal' do
      click_button 'Unschedule'
    end

    expect(page).to have_content 'There are no restoration applications currently scheduled.'
  end
end
