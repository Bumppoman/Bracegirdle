require 'rails_helper'

feature 'Complaints' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery,
      name: 'Anthony Cemetery',
      county: 4,
      order_id: 1)
  end

  scenario 'Unauthorized user tries to add complaint' do
    expect { visit new_complaint_path }.to raise_error(ApplicationController::Forbidden)
  end

  scenario 'Investigator adds complaint', js: true do
    login
    visit root_path

    click_on 'Complaints'
    click_on 'Add new complaint'
    fill_in 'complaint[complainant_name]', with: 'Herman Munster'
    fill_in 'complaint[complainant_address]', with: '1313 Mockingbird Ln., Rotterdam, NY 13202'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', css: '#complaint-cemetery-select-area'
    select2 'Burial issues', from: 'Complaint Type'
    fill_in 'complaint[summary]', with: 'Testing.'
    fill_in 'complaint[form_of_relief]', with: 'Testing'
    fill_in 'complaint[date_of_event]', with: '12/31/2018'
    all('span', text: 'Yes').last.click
    select2 'Chester Butkiewicz', from: 'Investigator'
    click_on 'Submit'
    visit complaints_path

    expect(page).to have_content('Herman Munster')
  end

  scenario 'User adds complaint without a summary', js: true do
    login
    visit root_path

    click_on 'Complaints'
    click_on 'Add new complaint'
    fill_in 'complaint[complainant_name]', with: 'Herman Munster'
    fill_in 'complaint[complainant_address]', with: '1313 Mockingbird Ln., Rotterdam, NY 13202'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', css: '#complaint-cemetery-select-area'
    select2 'Burial issues', from: 'Complaint Type'
    fill_in 'complaint[form_of_relief]', with: 'Testing'
    fill_in 'complaint[date_of_event]', with: '12/31/2018'
    all('span', text: 'Yes').last.click
    select2 'Chester Butkiewicz', from: 'Investigator'
    click_on 'Submit'

    expect(page).to have_content('There was a problem')
  end

  scenario 'Complaint can advance through investigation', js: true do
    login
    @complaint = FactoryBot.create(:brand_new_complaint)

    visit complaints_path
    click_on @complaint.complaint_number
    click_on 'Investigation Details'
    click_button 'Begin Investigation'
    sleep(1)
    click_button 'Complete Investigation'
    fill_in 'complaint[disposition]', with: 'Testing.'
    click_button 'Recommend Complaint for Closure'
    visit complaints_path

    expect(page).to have_content('There are no complaints')
  end

  scenario 'Complaint pending closure can be reviewed', js: true do
    login_supervisor
    @complaint = FactoryBot.create(:complaint_pending_closure)

    visit complaints_pending_closure_path
    click_on @complaint.complaint_number
    click_on 'Investigation Details'
    click_on 'Close Complaint'
    visit complaints_pending_closure_path

    expect(page).to have_content('There are no complaints')
  end

  scenario 'Supervisor can close his own complaint directly', js: true do
    login_supervisor
    @complaint = FactoryBot.create(:complaint_completed_investigation)

    visit complaints_path
    click_on @complaint.complaint_number
    click_on 'Investigation Details'

    expect(page).to have_content 'Close Complaint'
  end

  scenario 'Supervisor can reopen complaint', js: true do
    @employee = FactoryBot.create(:user)
    @complaint = FactoryBot.create(:complaint_pending_closure)
    login(FactoryBot.create(:mean_supervisor))

    visit complaints_pending_closure_path
    click_on @complaint.complaint_number
    click_on 'Investigation Details'
    click_button 'Reopen Investigation'
    visit complaints_path

    expect(page).to have_content('Herman Munster')
  end

  scenario "Investigator cannot advance another investigator's complaint", js: true do
    @employee = FactoryBot.create(:user)
    @complaint = FactoryBot.create(:brand_new_complaint)
    login(FactoryBot.create(:another_investigator))

    visit complaint_path(@complaint)
    click_on 'Investigation Details'

    expect(page).to_not have_button 'Begin Investigation'
  end

  scenario "Supervisor can reopen complaint that had no investigation initially", js: true do
    @employee = FactoryBot.create(:user)
    @complaint = FactoryBot.create(:no_investigation_complaint)
    login(FactoryBot.create(:mean_supervisor))

    visit complaint_path(@complaint)
    click_on 'Investigation Details'
    click_button 'Reopen Investigation'
    visit complaints_path

    expect(page).to have_content(@complaint.complaint_number)
  end

  scenario 'Investigator can add note to complaint', js: true do
    login
    @complaint = FactoryBot.create(:brand_new_complaint)

    visit complaint_path(@complaint)
    click_on 'Investigation Details'
    fill_in 'note[body]', with: 'Adding a note to this complaint'
    click_on 'Submit'

    expect(page).to have_content 'Adding a note to this complaint'
  end

  scenario "Note can't be added to a closed complaint", js: true do
    login
    @complaint = FactoryBot.create(:complaint_pending_closure)

    visit complaint_path(@complaint)
    click_on 'Investigation Details'

    expect(page).to_not have_content 'ADD NEW NOTE'
  end

  scenario 'Investigator can upload attachment', js: true do
    login
    @complaint = FactoryBot.create(:brand_new_complaint)

    visit complaint_path(@complaint)
    click_on 'Investigation Details'
    attach_file 'attachment_file', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    fill_in 'attachment[description]', with: 'Adding an attachment to this complaint'
    click_on 'Upload'

    expect(page).to have_content 'Adding an attachment to this complaint'
  end

  scenario "Attachment can't be added to a closed complaint", js: true do
    login
    @complaint = FactoryBot.create(:complaint_pending_closure)

    visit complaint_path(@complaint)
    click_on 'Investigation Details'

    expect(page).to_not have_content 'UPLOAD ATTACHMENT'
  end

  scenario 'Assigning a complaint sends a notification', js: true do
    @employee = FactoryBot.create(:user)
    login(FactoryBot.create(:mean_supervisor))
    click_on 'Complaints'
    click_on 'Add new complaint'
    fill_in 'complaint[complainant_name]', with: 'Herman Munster'
    fill_in 'complaint[complainant_address]', with: '1313 Mockingbird Ln., Rotterdam, NY 13202'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', css: '#complaint-cemetery-select-area'
    select2 'Burial issues', from: 'Complaint Type'
    fill_in 'complaint[summary]', with: 'Testing.'
    fill_in 'complaint[form_of_relief]', with: 'Testing'
    fill_in 'complaint[date_of_event]', with: '12/31/2018'
    all('span', text: 'Yes').last.click
    select2 'Chester Butkiewicz', from: 'Investigator'
    click_on 'Submit'
    logout
    login

    visit root_path
    click_on class: 'header-notification'

    expect(page).to have_content('John Smith assigned a complaint')
  end
end