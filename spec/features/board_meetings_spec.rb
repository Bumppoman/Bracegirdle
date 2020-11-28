require 'rails_helper'

feature 'Board Meetings' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
    @contractor = FactoryBot.create(:contractor)
    @application = FactoryBot.create(:reviewed_hazardous)
  end
  
  scenario 'Supervisor can create board meeting', js: true do
    login_supervisor
    
    visit board_meetings_path
    click_button 'Add board meeting'
    fill_in 'Location', with: '99 Washington Avenue, Albany, NY 12231'
    click_button 'Add New Board Meeting'
    
    expect(page).to have_content "#{Date.current.strftime('%B %Y').upcase} BOARD MEETING"
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
