require 'rails_helper'

feature 'Board Meetings' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
    @contractor = FactoryBot.create(:contractor)
    @application = FactoryBot.create(:reviewed_hazardous)
  end

  scenario 'User can finalize agenda', js: true do
    @board_meeting = FactoryBot.create(:board_meeting, date: '2028-03-01')
    login_supervisor
    
    visit board_meeting_path(@board_meeting)
    click_button 'Finalize agenda'
    within '#bracegirdle-confirmation-modal' do
      click_button 'Finalize Agenda'
    end
    assert_selector '.disappearing-success-message'
    
    expect(@board_meeting.reload.status).to eq 'agenda_finalized'
  end

  scenario 'User can download PDF agenda' do
    @board_meeting = FactoryBot.create(:board_meeting, date: '2028-03-01')
    login

    visit download_agenda_board_meeting_path(@board_meeting, filename: "Agenda-#{@board_meeting.date.strftime('%F')}")

    expect(page.status_code).to be 200
  end
end
