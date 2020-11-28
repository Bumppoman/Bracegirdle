require 'rails_helper'

feature 'Notifications' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
  end

  scenario 'Assigning a complaint sends a notification', js: true do
    @employee = FactoryBot.create(:user)
    login(FactoryBot.create(:mean_supervisor))
    visit new_complaint_path
    fill_in 'Name', with: 'Herman Munster'
    fill_in 'Street Address', with: '1313 Mockingbird Ln.'
    fill_in 'City', with: 'Rotterdam'
    choices 'NY', from: 'State'
    fill_in 'ZIP Code', with: '13202'
    fill_in 'Phone Number', with: '518-555-3232'
    fill_in 'Email', with: 'test@test.test'
    choices 'Broome', from: 'County'
    choices '04-001 Anthony Cemetery', css: '[data-target="complaints--new.cemeterySelectArea"]'
    fill_in 'Location of Lot/Grave', with: 'Section 12 Row 7'
    fill_in 'Name on Deed', with: 'Mother Butkiewicz'
    fill_in 'Relationship', with: 'Relationship'
    choices 'Burial issues', from: 'Complaint Type'
    fill_in 'complaint[summary]', with: 'Testing.'
    fill_in 'complaint[form_of_relief]', with: 'Testing'
    fill_in 'complaint[date_of_event]', with: '12/31/2018'
    fill_in 'Date Complained to Cemetery', with: '1/1/2019'
    fill_in 'Person Contacted', with: 'Clive Bixby'
    all('span', text: 'Yes').last.click
    choices 'Chester Butkiewicz', from: 'Investigator'
    click_on 'Submit'
    assert_selector '#complaint-details'
    logout
    login(@employee)

    visit root_path
    find('#notifications .header-notification').click

    expect(page).to have_content 'John Smith assigned a complaint'
  end

  scenario 'Adding a new rules approval for another user sends a notification', js: true do
    @employee = FactoryBot.create(:user)
    @trustee = FactoryBot.create(:trustee)
    login(FactoryBot.create(:mean_supervisor))
    visit new_rules_approval_path
    choices 'Broome', from: 'County'
    choices '04-001 Anthony Cemetery', from: 'Cemetery'
    choices 'Mark Clark (President)', from: 'Submitted By'
    fill_in 'Address', with: '223 Fake St.'
    fill_in 'City', with: 'Rotterdam'
    choices 'PA', from: 'State'
    fill_in 'ZIP Code', with: '12345'
    attach_file 'rules_approval_rules_document', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    choices 'Chester Butkiewicz', from: 'Investigator'
    click_button 'Upload Rules'
    logout
    login(@employee)

    visit root_path
    find('#notifications .header-notification').click

    expect(page).to have_content 'John Smith uploaded new rules'
  end

  scenario "Commenting on someone's item sends a notification", js: true do
    @employee = FactoryBot.create(:user)
    @complaint = FactoryBot.create(:brand_new_complaint)
    login(FactoryBot.create(:mean_supervisor))

    visit complaint_path(@complaint)
    click_on 'Investigation Details'
    fill_in 'note[body]', with: 'Testing'
    click_on 'submit-note-button'
    logout
    login(@employee)
    find('#notifications .header-notification').click

    expect(page).to have_content 'John Smith added a comment'
  end

  scenario 'Individual notifications can be marked read', js: true do
    @employee = FactoryBot.create(:user)
    @supervisor = FactoryBot.create(:mean_supervisor)
    @complaint = FactoryBot.create(:brand_new_complaint, receiver_id: 2)
    @notification = FactoryBot.create(:notification, object: @complaint, message: 'added')

    login(@employee)
    find('#notifications .header-notification').click

    expect {
      find('.notification-link[data-notification-id="1"]').click
      assert_no_selector '.badge[data-target="main.notificationsUnreadIndicator"]'
    }.to change { Notification.first.read }
  end

  scenario 'All notifications can be marked read', js: true do
    @employee = FactoryBot.create(:user)
    @supervisor = FactoryBot.create(:mean_supervisor)
    @complaint = FactoryBot.create(:brand_new_complaint, receiver_id: 2)
    @notification = FactoryBot.create(:notification, object: @complaint, message: 'added')
    @second_notification = FactoryBot.create(:notification, object: @complaint, message: 'added')

    login(@employee)
    find('#notifications .header-notification').click

    expect {
      click_link 'Mark All as Read'
      assert_no_selector '.badge[data-target="main.notificationsUnreadIndicator"]'
    }.to change {
      Notification.first.read
      Notification.last.read
    }
  end
end
