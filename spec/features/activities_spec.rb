require 'rails_helper'

feature 'Activities' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
    @year = Date.today.year
  end

  scenario 'Adding a complaint logs activity', js: true do
    login
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
    click_on 'Dashboard', match: :first

    expect(page).to have_content 'Chester Butkiewicz began investigating a complaint against Anthony Cemetery'
  end

  scenario 'Adding note to complaint logs activity', js: true do
    login
    @complaint = FactoryBot.create(:brand_new_complaint)
    visit complaint_path(@complaint)
    click_on 'Investigation Details'
    fill_in 'note[body]', with: 'Adding a note to this complaint'
    click_on 'Submit'
    visit complaint_path(@complaint) # Necessary to fix a timing issue

    click_on 'Dashboard', match: :first

    expect(page).to have_content "Chester Butkiewicz commented on complaint #CPLT-#{@year}-00001 against Anthony Cemetery"
  end

  scenario 'Adding new rules approval logs activity', js: true do
    login
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
    click_on 'Dashboard', match: :first

    expect(page).to have_content 'Chester Butkiewicz uploaded new rules submitted for approval by Anthony Cemetery'
  end

  scenario 'Approving rules logs activity', js: true do
    @rules_approval = FactoryBot.create(:rules_approval)
    @rules_approval.update(investigator_id: 1)
    login_supervisor
    visit rules_approval_path(@rules_approval)
    click_button 'Approve'
    within '#bracegirdle-confirmation-modal' do
      click_button 'Approve Rules'
    end
    assert_selector '.disappearing-success-message'
    
    visit root_path

    expect(page).to have_content 'Chester Butkiewicz approved rules for Anthony Cemetery'
  end

  scenario 'Assigning rules logs activity', js: true do
    @rules_approval = FactoryBot.create(:rules_approval)
    login_supervisor
    @him = FactoryBot.create(:another_investigator)
    
    visit rules_approval_path(@rules_approval)
    click_button 'Assign'
    within '#rules_approval-assign-investigator-modal' do
      choices 'Bob Wood', css: '.choices'
      click_on 'Assign'
    end
    click_on 'Dashboard', match: :first

    expect(page).to have_content 'Chester Butkiewicz assigned rules for Anthony Cemetery to Bob Wood'
  end

  scenario 'Uploading a revision to rules approval logs activity', js: true do
    @rules_approval = FactoryBot.create(:revision_requested)
    login
    visit rules_approval_path(@rules_approval)
    attach_file 'revision_rules_document', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    click_button 'Upload Revision'
    assert_selector '.disappearing-success-message'

    click_on 'Dashboard', match: :first

    expect(page).to have_content 'Chester Butkiewicz received a revision to rules for Anthony Cemetery'
  end

  scenario 'Issuing a notice logs activity', js: true do
    login
    visit new_notice_path
    choices 'Broome', from: 'County'
    choices '04-001 Anthony Cemetery', from: 'Cemetery'
    choices 'Mark Clark (President)', from: 'Served On'
    fill_in 'Address', with: '1313 Mockingbird Ln.'
    fill_in 'City', with: 'Philadelphia'
    choices 'PA', from: 'State'
    fill_in 'ZIP Code', with: '12345'
    fill_in 'Law Sections', with: 'Testing.'
    fill_in 'Specific Information', with: 'Testing.'
    fill_in 'Violation Date', with: '12/31/2018'
    fill_in 'Response Required', with: '12/31/2019'
    click_on 'Issue Notice'
    visit notices_path

    click_on 'Dashboard', match: :first

    expect(page).to have_content "Chester Butkiewicz issued Notice of Non-Compliance #BNG-#{@year}-00001 to Anthony Cemetery"
  end

  scenario 'Receiving a response to a notice logs activity', js: true do
    login
    @notice = FactoryBot.create(:notice)
    visit notices_path
    click_on @notice.notice_number
    click_button 'Response Received'
    within '#bracegirdle-confirmation-modal' do 
      click_button 'Response Received'
    end 

    click_on 'Dashboard', match: :first

    expect(page).to have_content "Chester Butkiewicz received a response to Notice of Non-Compliance #BNG-#{@year}-00001 from Anthony Cemetery"
  end

  scenario 'Uploading a hazardous monument application logs activity', js: true do
    login
    visit board_applications_hazardous_index_path
    click_on 'Upload new application'
    choices 'Broome', from: 'County'
    choices '#04-001 Anthony Cemetery', from: 'Cemetery'
    choices 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'hazardous_raw_application_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    choices 'Chester Butkiewicz', from: 'Assign To'
    click_on 'Upload Application'
    click_on 'Applications'
    click_on 'Hazardous Monuments'

    click_on 'Dashboard', match: :first

    expect(page).to have_content 'Chester Butkiewicz received a restoration application for Anthony Cemetery'
  end
end
