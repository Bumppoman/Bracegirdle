require 'rails_helper'

feature 'Board Meetings' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
    @contractor = FactoryBot.create(:contractor)
    @application = FactoryBot.create(:reviewed_hazardous)
  end

  scenario 'User can finalize agenda', js: true do
    login_supervisor
  end

  scenario 'User can download PDF agenda' do
    @board_meeting = FactoryBot.create(:board_meeting, date: '2028-03-01')
    login

    visit download_agenda_board_meeting_path(@board_meeting, filename: "Agenda-#{@board_meeting.date.strftime('%F')}")

    expect(page.status_code).to be 200
  end
end
