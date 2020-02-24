require 'rails_helper'

feature 'Hazardous' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
    @contractor = FactoryBot.create(:contractor)
  end

  scenario 'Hazardous monument application can be uploaded', js: true do
    login

    visit applications_hazardous_index_path # Visit is ok because we are not waiting on anything
    assert_selector '#application-data-table'
    click_on 'Upload new application'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'hazardous_raw_application_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    click_on 'Upload Application'
    assert_selector '#process-restoration'
    click_on 'Applications'
    click_on 'Hazardous Monuments'

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'Hazardous monument application without necessary information cannot be saved', js: true do
    login

    visit applications_hazardous_index_path # Visit is ok because we are not waiting on anything
    assert_selector '#application-data-table'
    click_on 'Upload new application'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    fill_in 'Amount', with: '12345.67'
    attach_file 'hazardous_raw_application_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    click_on 'Upload Application'

    assert_selector '#new-application-error'
    expect(page).to have_content 'There was a problem'
  end

  scenario 'Hazardous monument application can be processed', js: true do
    login

    visit applications_hazardous_index_path # Visit is ok because we are not waiting on anything
    assert_selector '#application-data-table'
    click_on 'Upload new application'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
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
    click_on 'Add New Estimate'
    attach_file 'estimate_document', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    fill_in 'Amount', with: '12845.67'
    select2 'Stony Rocks Monuments', from: 'Contractor', tag: true
    select2 'Lifetime', from: 'Warranty'
    choose 'estimate_proper_format_true'
    click_on 'Upload Estimate'
    assert_selector '#estimate-2'
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
    click_on 'Submit for Consideration'
    assert_selector '#restoration-exhibits'
    click_on 'Dashboard', match: :first
    visit applications_hazardous_index_path

    expect(page).to have_content 'Sent to supervisor'
  end

  scenario 'Supervisor can send application directly to cemetery board', js: true do
    login_supervisor

    visit applications_hazardous_index_path # Visit is ok because we are not waiting on anything
    click_on 'Upload new application'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
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
    click_on 'Submit for Consideration'
    assert_selector '#restoration-exhibits'
    click_on 'Dashboard', match: :first
    visit applications_hazardous_index_path

    expect(page).to have_content 'Sent to Cemetery Board'
  end

  context 'Viewing portions of the application' do
    before :each do
      @restoration = FactoryBot.create(:processed_hazardous)
    end

    scenario 'View raw application' do
      login

      visit view_raw_application_applications_hazardous_path(@restoration)

      expect(page).to have_content 'View Raw Application'
    end

    scenario 'View application form' do
      login

      visit view_application_form_applications_hazardous_path(@restoration)

      expect(page).to have_content 'View Application Form'
    end

    scenario 'View legal notice' do
      login

      visit view_legal_notice_applications_hazardous_path(@restoration)

      expect(page).to have_content 'View Legal Notice'
    end

    scenario 'View estimate' do
      login

      visit view_estimate_applications_hazardous_path(@restoration, @restoration.estimates.first)

      expect(page).to have_content 'View Rocky Stone Monuments estimate'
    end

    scenario 'View previous report' do
      login

      visit view_previous_report_applications_hazardous_path(@restoration)

      expect(page).to have_content 'View Previous Restoration Report'
    end

    scenario 'View generated report' do
      login

      visit view_report_applications_hazardous_path(@restoration)

      expect(page.status_code).to be 200
    end

    scenario 'View combined report' do
      login

      visit view_combined_applications_hazardous_path(@restoration)

      expect(page.status_code).to be 200
    end
  end

  context Hazardous, 'Reviewing application' do
    before :each do
      @restoration = FactoryBot.create(:processed_hazardous)
    end

    scenario 'Supervisor can send application to board', js: true do
      login_supervisor
      visit applications_hazardous_index_path # Visit is ok because we are not waiting on anything
      click_on @restoration.identifier

      click_on 'Send to cemetery board'
      assert_selector '#application-data-table'

      expect(@restoration.reload.status).to eq 'reviewed'
    end

    scenario 'Supervisor can return application to investigator', js: true do
      login_supervisor
      visit review_applications_hazardous_path(@restoration)

      click_on 'Return to investigator'
      assert_selector '#application-data-table'

      expect(@restoration.reload.status).to eq 'received'
    end
  end
end
