require 'rails_helper'

feature 'Restoration' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
    @contractor = FactoryBot.create(:contractor)
  end

  context Restoration, 'Viewing lists of applications' do
    scenario 'Abandonment applications can be viewed' do
      @abandonment = FactoryBot.create(:abandonment)
      login

      visit restoration_index_path(:abandonment)

      expect(page).to have_content('Anthony Cemetery')
    end

    scenario 'Vandalism applications can be viewed' do
      @vandalism = FactoryBot.create(:vandalism)
      login

      visit restoration_index_path(:vandalism)

      expect(page).to have_content('Anthony Cemetery')
    end
  end

  scenario 'Hazardous monument application can be uploaded', js: true do
    login
    visit root_path

    click_on 'Applications'
    click_on 'Hazardous Monuments'
    assert_selector '#restoration-data-table'
    click_on 'Upload new application'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    select2 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'restoration_raw_application_file', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    click_on 'Upload Application'
    wait_for_ajax
    click_on 'Applications'
    click_on 'Hazardous Monuments'

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'Hazardous monument application without necessary information cannot be saved', js: true do
    login

    click_on 'Applications'
    click_on 'Hazardous Monuments'
    assert_selector '#restoration-data-table'
    click_on 'Upload new application'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    select2 'Mark Clark', from: 'Submitted By'
    fill_in 'Amount', with: '12345.67'
    attach_file 'restoration_raw_application_file', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    click_on 'Upload Application'

    assert_selector '#new-restoration-error'
    expect(page).to have_content 'There was a problem'
  end

  scenario 'Hazardous monument application can be processed', js: true do
    login

    click_on 'Applications'
    click_on 'Hazardous Monuments'
    assert_selector '#restoration-data-table'
    click_on 'Upload new application'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    select2 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'restoration_raw_application_file', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    click_on 'Upload Application'
    wait_for_ajax
    attach_file 'restoration_application_form', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    fill_in 'Number of Monuments', with: 25
    fill_in 'Date of Visit to Cemetery', with: '2/8/2019'
    choose 'restoration_application_form_complete_true'
    click_on 'Next'
    click_on 'Add New Estimate'
    attach_file 'estimate_document', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    fill_in 'Amount', with: '12345.67'
    select2 'Rocky Stone Monuments', from: 'Contractor'
    select2 'Lifetime', from: 'Warranty'
    choose 'estimate_proper_format_true'
    click_on 'Upload Estimate'
    click_on 'Add New Estimate'
    attach_file 'estimate_document', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    fill_in 'Amount', with: '12845.67'
    select2 'Stony Rocks Monuments', from: 'Contractor', tag: true
    select2 'Lifetime', from: 'Warranty'
    choose 'estimate_proper_format_true'
    click_on 'Upload Estimate'
    click_on 'Next'
    attach_file 'restoration_legal_notice', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    fill_in 'Cost', with: '123.45'
    fill_in 'Newspaper', with: 'Albany Sun'
    choose 'restoration_legal_notice_format_true'
    click_on 'Next'
    choose 'restoration_previous_exists_true'
    attach_file 'restoration_previous_report', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    select2 'Hazardous', from: 'Type of Project'
    fill_in 'Date Previous Work Approved', with: 'September 2017'
    click_on 'Next'
    click_on 'Submit for Consideration'
    wait_for_ajax
    click_on 'Dashboard', match: :first
    visit restoration_index_path(type: :hazardous)

    expect(page).to have_content 'Sent to supervisor'
  end

  scenario 'Supervisor can send application directly to cemetery board', js: true do
    login_supervisor

    click_on 'Applications'
    click_on 'Hazardous Monuments'
    assert_selector '#restoration-data-table'
    click_on 'Upload new application'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    select2 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'restoration_raw_application_file', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    click_on 'Upload Application'
    wait_for_ajax
    attach_file 'restoration_application_form', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    fill_in 'Number of Monuments', with: 25
    fill_in 'Date of Visit to Cemetery', with: '2/8/2019'
    choose 'restoration_application_form_complete_true'
    click_on 'Next'
    click_on 'Add New Estimate'
    attach_file 'estimate_document', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    fill_in 'Amount', with: '12345.67'
    select2 'Rocky Stone Monuments', from: 'Contractor'
    select2 'Lifetime', from: 'Warranty'
    choose 'estimate_proper_format_true'
    click_on 'Upload Estimate'
    click_on 'Next'
    attach_file 'restoration_legal_notice', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    fill_in 'Cost', with: '123.45'
    fill_in 'Newspaper', with: 'Albany Sun'
    choose 'restoration_legal_notice_format_true'
    click_on 'Next'
    choose 'restoration_previous_exists_true'
    attach_file 'restoration_previous_report', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    select2 'Hazardous', from: 'Type of Project'
    fill_in 'Date Previous Work Approved', with: 'September 2017'
    click_on 'Next'
    click_on 'Submit for Consideration'
    wait_for_ajax
    click_on 'Dashboard', match: :first
    visit restoration_index_path(type: :hazardous)

    expect(page).to have_content 'Sent to Cemetery Board'
  end

  context 'Viewing portions of the application' do
    before :each do
      @restoration = FactoryBot.create(:processed_hazardous)
    end

    scenario 'View raw application' do
      login

      visit view_raw_application_restoration_path(@restoration, type: :hazardous)

      expect(page).to have_content 'View Raw Application'
    end

    scenario 'View application form' do
      login

      visit view_application_form_restoration_path(@restoration, type: :hazardous)

      expect(page).to have_content 'View Application Form'
    end

    scenario 'View legal notice' do
      login

      visit view_legal_notice_restoration_path(@restoration, type: :hazardous)

      expect(page).to have_content 'View Legal Notice'
    end

    scenario 'View estimate' do
      login

      visit view_estimate_restoration_path(@restoration, @restoration.estimates.first, type: :hazardous)

      expect(page).to have_content 'View Rocky Stone Monuments estimate'
    end

    scenario 'View previous report' do
      login

      visit view_previous_report_restoration_path(@restoration, type: :hazardous)

      expect(page).to have_content 'View Previous Restoration Report'
    end

    scenario 'View generated report' do
      login

      visit view_report_restoration_path(@restoration, type: :hazardous)

      expect(page.status_code).to be 200
    end

    scenario 'View combined report' do
      login

      visit view_combined_restoration_path(@restoration, type: :hazardous)

      expect(page.status_code).to be 200
    end
  end

  context Restoration, 'Reviewing application' do
    before :each do
      @restoration = FactoryBot.create(:processed_hazardous)
    end

    scenario 'Supervisor can send application to board', js: true do
      login_supervisor
      click_on 'Applications'
      click_on 'Hazardous Monuments'
      click_on @restoration.identifier

      click_on 'Send to cemetery board'
      assert_selector '#restoration-data-table'

      expect(@restoration.reload.status).to eq 'reviewed'
    end

    scenario 'Supervisor can return application to investigator', js: true do
      login_supervisor
      visit review_restoration_path(@restoration, type: :hazardous)

      click_on 'Return to investigator'
      assert_selector '#restoration-data-table'

      expect(@restoration.reload.status).to eq 'received'
    end
  end
end