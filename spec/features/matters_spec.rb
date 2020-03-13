require 'rails_helper'

feature 'Matters' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
    @contractor = FactoryBot.create(:contractor)
    @application = FactoryBot.create(:reviewed_hazardous)
    @board_meeting = FactoryBot.create(:board_meeting, date: '2028-03-01')
    @matter = FactoryBot.create(:matter, application: @application)
  end

  scenario 'Matters can be scheduled for a board meeting', js: true do
    login

    visit applications_schedulable_path # Visit is ok because we are not waiting on anything
    click_on 'Schedule'
    choose 'matter_board_meeting_1'
    click_on 'Schedule Matter'
    assert_selector '.dataTables_empty'
    visit board_meetings_path # Visit is ok because we are not waiting on anything
    click_on 'March 2028'

    expect(page).to have_content 'Anthony Cemetery (#04-001) – Hazardous'
  end

  scenario 'Scheduled matters can be unscheduled', js: true do
    login
    visit applications_schedulable_path # Visit is ok because we are not waiting on anything
    click_on 'Schedule'
    choose 'matter_board_meeting_1'
    click_on 'Schedule Matter'
    assert_selector '.dataTables_empty'
    visit board_meetings_path # Visit is ok because we are not waiting on anything
    click_on 'March 2028'

    click_on 'Unschedule'
    click_on 'Unschedule Matter'

    expect(page).to have_content 'There are no restoration applications currently scheduled.'
  end
end
