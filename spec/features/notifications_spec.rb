require 'rails_helper'

feature 'Notifications' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
  end

  scenario 'Assigning a complaint sends a notification', js: true do
    @employee = FactoryBot.create(:user)
    login(FactoryBot.create(:mean_supervisor))
    visit new_complaint_path
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
    login(@employee)

    visit root_path
    click_on class: 'header-notification'

    expect(page).to have_content 'John Smith assigned a complaint'
  end

  scenario 'Adding new rules for another user sends a notification', js: true do
    @employee = FactoryBot.create(:user)
    login(FactoryBot.create(:mean_supervisor))
    click_on 'Inbox'
    click_on 'Rules and Regulations'
    click_on 'Upload new rules'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    fill_in 'Sender', with: 'Mark Smith'
    fill_in 'Address', with: '223 Fake St.'
    fill_in 'City', with: 'Rotterdam'
    fill_in 'ZIP Code', with: '12345'
    attach_file 'rules_rules_documents', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    select2 'Chester Butkiewicz', from: 'Investigator'
    click_button 'Submit'
    wait_for_ajax
    logout
    login(@employee)

    visit root_path
    click_on class: 'header-notification'

    expect(page).to have_content 'John Smith uploaded new rules'
  end

  scenario 'Notifications can be marked read', js: true do
    @employee = FactoryBot.create(:user)
    login(FactoryBot.create(:mean_supervisor))
    click_on 'Inbox'
    click_on 'Rules and Regulations'
    click_on 'Upload new rules'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    fill_in 'Sender', with: 'Mark Smith'
    fill_in 'Address', with: '223 Fake St.'
    fill_in 'City', with: 'Rotterdam'
    fill_in 'ZIP Code', with: '12345'
    attach_file 'rules_rules_documents', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    select2 'Chester Butkiewicz', from: 'Investigator'
    click_button 'Submit'
    logout
    login(@employee)
    visit root_path
    click_on class: 'header-notification'

    expect {
      click_on 'notification-1'
      wait_for_ajax
    }.to change { Notification.first.read }

  end
end