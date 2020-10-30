require 'rails_helper'

feature 'Appointments' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
  end

  scenario 'User can schedule an appointment', js: true do
    login

    visit inspections_cemetery_path(@cemetery)
    click_on 'Schedule inspection'

    expect {
      within '#schedule-inspection-modal' do
        click_on 'Schedule inspection'
      end
      assert_selector '#appointments-data-table'
    }.to change { Appointment.count }
  end

  scenario 'User can begin an appointment', js: true do
    login
    @appointment = FactoryBot.create(:appointment)

    visit scheduled_cemetery_inspections_path
    click_on 'Begin'

    expect {
      click_on 'Begin Inspection'
      assert_selector '#cemetery_inspection-perform'
    }.to change { CemeteryInspection.count }
  end

  scenario 'User can reschedule an appointment', js: true do
    login
    @appointment = FactoryBot.create(:appointment)

    visit scheduled_cemetery_inspections_path
    click_on 'Reschedule'
    find('#appointment_time').set('12:30')
    click_on 'Reschedule inspection'

    expect(page).to have_content '12:30'
  end

  scenario 'User can cancel an appointment', js: true do
    login
    @appointment = FactoryBot.create(:appointment)

    visit scheduled_cemetery_inspections_path
    click_on 'Cancel'

    expect {
      click_on 'Cancel Inspection'
      assert_no_selector "[data-appointment-id='#{@appointment.id}']"
    }.to change { @appointment.reload.status }
  end
end
