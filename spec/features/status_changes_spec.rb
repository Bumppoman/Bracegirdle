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
    select2 'NY', from: 'State'
    fill_in 'ZIP Code', with: '13202'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', css: '#complaint-cemetery-select-area'
    select2 'Burial issues', from: 'Complaint Type'
    fill_in 'complaint[summary]', with: 'Testing.'
    fill_in 'complaint[form_of_relief]', with: 'Testing'
    fill_in 'complaint[date_of_event]', with: '12/31/2018'
    all('span', text: 'Yes').last.click
    select2 'Chester Butkiewicz', from: 'Investigator'
    expect {
      click_on 'Submit'
      assert_selector '#complaint-details'
    }.to change { StatusChange.count }
  end

  scenario 'Uploading a hazardous monument application tracks status', js: true do
    @trustee = FactoryBot.create(:trustee)
    @cemetery.trustees << @trustee
    login

    visit applications_hazardous_index_path # Visit is ok because we are not waiting on anything
    assert_selector '#application-data-table'
    click_on 'Upload new application'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    select2 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'hazardous_raw_application_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false

    expect {
      click_on 'Upload Application'
      assert_selector '#process-restoration'
    }.to change { StatusChange.count }
  end

  scenario 'Processing a hazardous monument application tracks status', js: true do
    @trustee = FactoryBot.create(:trustee)
    @cemetery.trustees << @trustee
    @contractor = FactoryBot.create(:contractor)
    login

    visit applications_hazardous_index_path # Visit is ok because we are not waiting on anything
    assert_selector '#application-data-table'
    click_on 'Upload new application'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    select2 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'hazardous_raw_application_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    click_on 'Upload Application'
    assert_selector '#process-restoration'
    attach_file 'hazardous_application_form', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    fill_in 'Number of Monuments', with: 25
    fill_in 'Date of Visit to Cemetery', with: '2/8/2019'
    choose 'hazardous_application_form_complete_true'
    click_on 'Next'
    assert_selector '#add-new-estimate'
    click_on 'Add New Estimate'
    attach_file 'estimate_document', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    fill_in 'Amount', with: '12345.67'
    select2 'Rocky Stone Monuments', from: 'Contractor'
    select2 'Lifetime', from: 'Warranty'
    choose 'estimate_proper_format_true'
    click_on 'Upload Estimate'
    assert_selector '#estimate-1'
    click_on 'Next'
    attach_file 'hazardous_legal_notice', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    fill_in 'Cost', with: '123.45'
    fill_in 'Newspaper', with: 'Albany Sun'
    choose 'hazardous_legal_notice_format_true'
    click_on 'Next'
    assert_selector '#restoration-previous-form'
    choose 'hazardous_previous_exists_true'
    attach_file 'hazardous_previous_report', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    select2 'Hazardous', from: 'Type of Project'
    fill_in 'Date Previous Work Approved', with: 'September 2017'
    click_on 'Next'

    expect {
      click_on 'Submit for Consideration'
      assert_selector '#restoration-exhibits'
    }.to change { StatusChange.count }
  end
end