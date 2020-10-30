require 'rails_helper'

feature 'Status Changes' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
  end

  scenario 'Adding a complaint tracks status', js: true do
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
    
    expect {
      click_on 'Submit'
      assert_selector '#complaint-details'
    }.to change { StatusChange.count }
  end

  scenario 'Uploading a hazardous monument application tracks status', js: true do
    @trustee = FactoryBot.create(:trustee)
    @cemetery.trustees << @trustee
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

    expect {
      click_on 'Upload Application'
      assert_selector '#board_applications-restorations-evaluate'
    }.to change { StatusChange.count }
  end

  scenario 'Evaluating a hazardous monument application tracks status', js: true do
    @trustee = FactoryBot.create(:trustee)
    @cemetery.trustees << @trustee
    @contractor = FactoryBot.create(:contractor)
    @second_contractor = FactoryBot.create(:contractor, name: 'Stony Rocks Monuments', county: 4)
    login

    visit board_applications_hazardous_index_path
    click_on 'Upload new application'
    choices 'Broome', from: 'County'
    choices '04-001 Anthony Cemetery', from: 'Cemetery'
    choices 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'hazardous_raw_application_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    choices 'Chester Butkiewicz', from: 'Assign To'
    click_on 'Upload Application'
    attach_file 'hazardous_application_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    fill_in 'Number of Monuments', with: 25
    fill_in 'Date of Visit to Cemetery', with: '2/8/2019'
    find('#application-form-complete-yes').click
    click_on 'Next'
    click_on 'Add Estimate'
    within('#board_applications-restorations-estimates-new-modal') do
      attach_file 'estimate_document', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
      fill_in 'Amount', with: '12345.67'
      choices 'Rocky Stone Monuments', from: 'Contractor'
      choices 'Lifetime', from: 'Warranty'
      find('#estimate-proper-format-yes').click
      click_button 'Add Estimate'
    end
    click_on 'Add Estimate'
    within('#board_applications-restorations-estimates-new-modal') do
      attach_file 'estimate_document', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
      fill_in 'Amount', with: '12845.67'
      choices 'Stony Rocks Monuments', from: 'Contractor'
      choices 'Lifetime', from: 'Warranty'
      find('#estimate-proper-format-yes').click
      click_button 'Add Estimate'
    end
    click_on 'Next'
    attach_file 'hazardous_legal_notice_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    fill_in 'Cost', with: '123.45'
    fill_in 'Newspaper', with: 'Albany Sun'
    find('#legal-notice-proper-format-yes').click
    click_on 'Next'
    assert_selector('#board_applications-restorations-previous-form') # Blocks for transition; necessary (10/2020)
    find('#previous-exists-yes').click
    attach_file 'hazardous_previous_completion_report_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    choices 'Hazardous', from: 'Type of Project'
    fill_in 'Date Previous Work Approved', with: '09/01/2017'
    click_on 'Next'

    expect {
      click_on 'Submit Application'
      assert_selector '#board_applications-restorations-show'
    }.to change { StatusChange.count }
  end

  scenario 'Scheduling a board matter tracks status for matter and application', js: true do
    @trustee = FactoryBot.create(:trustee)
    @board_application = FactoryBot.create(:reviewed_hazardous)
    @board_meeting = FactoryBot.create(:board_meeting, date: '2028-03-01')
    @matter = FactoryBot.create(:matter, board_application: @board_application)
    login

    visit schedulable_matters_path
    click_button 'Schedule'
    choose 'matter_board_meeting_1'

    expect {
      click_button 'Schedule Matter'
      assert_selector '.disappearing-success-message'
    }.to change { StatusChange.count }.by(2)
  end
end
