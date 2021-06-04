require 'rails_helper'

feature 'Hazardous' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
    @contractor = FactoryBot.create(:contractor)
    @second_contractor = FactoryBot.create(:contractor, name: 'Stony Rocks Monuments', county: 4)
  end

  scenario 'Hazardous monument application can be uploaded', js: true do
    login

    visit board_applications_hazardous_index_path
    click_link 'Upload new application'
    choices 'Broome', from: 'County'
    choices '#04-001 Anthony Cemetery', from: 'Cemetery'
    choices 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'hazardous_raw_application_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    choices 'Chester Butkiewicz', from: 'Assign To'
    click_button 'Upload Application'
    find('span', text: 'APPLICATIONS').click
    click_link 'Hazardous Monuments'

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'Hazardous monument application without necessary information cannot be saved', js: true do
    login

    visit board_applications_hazardous_index_path
    click_link 'Upload new application'
    choices 'Broome', from: 'County'
    choices '#04-001 Anthony Cemetery', from: 'Cemetery'
    choices 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    choices 'Chester Butkiewicz', from: 'Assign To'
    click_button 'Upload Application'

    expect(page).to have_content 'There was a problem uploading this application!'
  end

  scenario 'Hazardous monument application can be evaluated', js: true do
    login

    visit board_applications_hazardous_index_path
    click_link 'Upload new application'
    choices 'Broome', from: 'County'
    choices '04-001 Anthony Cemetery', from: 'Cemetery'
    choices 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'hazardous_raw_application_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    choices 'Chester Butkiewicz', from: 'Assign To'
    click_button 'Upload Application'
    attach_file 'hazardous_application_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    fill_in 'Number of Monuments', with: 25
    fill_in 'Date of Visit to Cemetery', with: '2/8/2019'
    choose id: 'hazardous_application_form_complete_true'
    click_button 'Next'
    click_button 'Add Estimate'
    within('#board_applications-restorations-estimates-new-modal') do
      attach_file 'estimate_document', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
      fill_in 'Amount', with: '12345.67'
      choices 'Rocky Stone Monuments', from: 'Contractor'
      choices 'Lifetime', from: 'Warranty'
      choose id: 'estimate_proper_format_true'
      click_button 'Add Estimate'
    end
    click_button 'Add Estimate'
    within('#board_applications-restorations-estimates-new-modal') do
      attach_file 'estimate_document', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
      fill_in 'Amount', with: '12845.67'
      choices 'Stony Rocks Monuments', from: 'Contractor'
      choices 'Lifetime', from: 'Warranty'
      choose id: 'estimate_proper_format_true'
      click_button 'Add Estimate'
    end
    click_button 'Next'
    attach_file 'hazardous_legal_notice_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    fill_in 'Cost', with: '123.45'
    fill_in 'Newspaper', with: 'Albany Sun'
    choose id: 'hazardous_legal_notice_format_true'
    click_button 'Next'
    assert_selector('#board_applications-restorations-previous-form') # Blocks for transition; necessary (10/2020)
    choose id: 'hazardous_previous_exists_true'
    attach_file 'hazardous_previous_completion_report_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    choices 'Hazardous', from: 'Type of Project'
    fill_in 'Date Previous Work Approved', with: '09/01/2017'
    find('label[for="hazardous_previous_date"]').click # Necessary to set file input value
    click_button 'Next'
    click_button 'Submit Application'
    assert_selector '#board_applications-restorations-show'
    visit board_applications_hazardous_index_path

    expect(page).to have_content 'Sent to supervisor'
  end

  scenario 'Supervisor sends application past review', js: true do
    login_supervisor

    visit board_applications_hazardous_index_path
    click_link 'Upload new application'
    choices 'Broome', from: 'County'
    choices '04-001 Anthony Cemetery', from: 'Cemetery'
    choices 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'hazardous_raw_application_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    choices 'Chester Butkiewicz', from: 'Assign To'
    click_button 'Upload Application'
    attach_file 'hazardous_application_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    fill_in 'Number of Monuments', with: 25
    fill_in 'Date of Visit to Cemetery', with: '2/8/2019'
    choose id: 'hazardous_application_form_complete_true'
    click_button 'Next'
    click_button 'Add Estimate'
    within('#board_applications-restorations-estimates-new-modal') do
      attach_file 'estimate_document', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
      fill_in 'Amount', with: '12345.67'
      choices 'Rocky Stone Monuments', from: 'Contractor'
      choices 'Lifetime', from: 'Warranty'
      choose id: 'estimate_proper_format_true'
      click_button 'Add Estimate'
    end
    click_button 'Add Estimate'
    within('#board_applications-restorations-estimates-new-modal') do
      attach_file 'estimate_document', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
      fill_in 'Amount', with: '12845.67'
      choices 'Stony Rocks Monuments', from: 'Contractor'
      choices 'Lifetime', from: 'Warranty'
      choose id: 'estimate_proper_format_true'
      click_button 'Add Estimate'
    end
    click_button 'Next'
    attach_file 'hazardous_legal_notice_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    fill_in 'Cost', with: '123.45'
    fill_in 'Newspaper', with: 'Albany Sun'
    choose id: 'hazardous_legal_notice_format_true'
    click_button 'Next'
    assert_selector('#board_applications-restorations-previous-form') # Blocks for transition; necessary (10/2020)
    choose id: 'hazardous_previous_exists_true'
    attach_file 'hazardous_previous_completion_report_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    choices 'Hazardous', from: 'Type of Project'
    fill_in 'Date Previous Work Approved', with: '09/01/2017'
    find('label[for="hazardous_previous_date"]').click # Necessary to set file input value
    click_button 'Next'
    click_button 'Submit Application'
    assert_selector '#board_applications-restorations-show'
    visit board_applications_hazardous_index_path

    expect(page).to have_content 'Ready for Cemetery Board'
  end
  
  scenario 'User can add note to an application', js: true do
    @restoration = FactoryBot.create(:evaluated_hazardous)
    login
    
    visit board_applications_hazardous_path(@restoration)
    fill_in 'note[body]', with: 'Adding a note to this application'
    click_button 'Submit'

    expect(page).to have_content 'Adding a note to this application'
  end

  context 'Viewing portions of the application' do
    before :each do
      @restoration = FactoryBot.create(:evaluated_hazardous)
    end

    scenario 'View raw application' do
      login

      visit view_raw_application_board_applications_hazardous_path(@restoration)

      expect(page).to have_content 'View Raw Application'
    end

    scenario 'View application form' do
      login

      visit view_application_form_board_applications_hazardous_path(@restoration)

      expect(page).to have_content 'View Application Form'
    end

    scenario 'View legal notice' do
      login

      visit view_legal_notice_board_applications_hazardous_path(@restoration)

      expect(page).to have_content 'View Legal Notice'
    end

    scenario 'View estimate' do
      login

      visit view_estimate_board_applications_hazardous_path(@restoration, @restoration.estimates.first)

      expect(page).to have_content 'View Rocky Stone Monuments estimate'
    end

    scenario 'View previous report' do
      login

      visit view_previous_report_board_applications_hazardous_path(@restoration)

      expect(page).to have_content 'View Previous Restoration Report'
    end

    scenario 'View generated report' do
      login

      visit view_report_board_applications_hazardous_path(@restoration)

      expect(page.status_code).to be 200
    end

    scenario 'View combined report' do
      login

      visit view_combined_board_applications_hazardous_path(@restoration)

      expect(page.status_code).to be 200
    end
  end

  context Hazardous, 'Reviewing application' do
    before :each do
      @user = FactoryBot.create(:another_investigator)
      @restoration = FactoryBot.create(:evaluated_hazardous)
    end

    scenario 'Supervisor can send application to board', js: true do
      login_supervisor
      visit board_applications_hazardous_index_path
      click_link @restoration.identifier

      click_button 'Approve for Cemetery Board'
      within '#bracegirdle-confirmation-modal' do
        click_button 'Approve Application'
      end
      assert_selector '#board_applications-restorations-show'

      expect(@restoration.reload.status).to eq 'reviewed'
    end

    scenario 'Supervisor can return application to investigator', js: true do
      login_supervisor
      visit review_board_applications_hazardous_path(@restoration)

      click_button 'Return to investigator'
      within '#bracegirdle-confirmation-modal' do
        click_button 'Return to Investigator'
      end
      assert_selector '#board_applications-restorations-show'
      
      expect(@restoration.reload.status).to eq 'assigned'
    end
  end
end
