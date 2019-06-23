require 'rails_helper'

feature 'Appointments' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
  end

  scenario 'User can schedule an appointment', js: true do
    login

    visit inspections_cemetery_path(@cemetery)
    click_on 'Schedule inspection'
    fill_in 'appointment[time]', with: '12:00 PM'

    expect {
      within '#schedule-inspection' do
        click_on 'Schedule inspection'
      end
      assert_selector '#appointments-data-table'
    }.to change { Appointment.count }
  end

  scenario 'User can begin an appointment', js: true do
    login
    @appointment = FactoryBot.create(:appointment)

    visit scheduled_inspections_path
    click_on 'Begin'

    expect {
      click_on 'Begin inspection'
      assert_selector '#perform-inspection'
    }.to change { CemeteryInspection.count }
  end

  scenario 'User can reschedule an appointment', js: true do
    login
    @appointment = FactoryBot.create(:appointment)

    visit scheduled_inspections_path
    click_on 'Reschedule'
    fill_in 'appointment[time]', with: (Time.now + 1.hour).strftime('%I:%M %p')
    click_on 'Reschedule inspection'
    assert_selector '#reschedule-success'

    expect(page).to have_content (Time.now + 1.hour).strftime('%I:%M %p')
  end

  scenario 'User can cancel an appointment', js: true do
    login
    @appointment = FactoryBot.create(:appointment)

    visit scheduled_inspections_path
    click_on 'Cancel'

    expect {
      click_on 'Cancel inspection'
      assert_no_selector '#appointment-1', wait: 2
    }.to change { @appointment.reload.status }
  end
end
