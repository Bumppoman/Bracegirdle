require 'rails_helper'

feature 'Cemetery Inspections' do
  before :each do
    stub_request(:get, /nominatim.openstreetmap.org/).
        with(
            headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'User-Agent'=>'Ruby'
            }).
        to_return(status: 200, body: {}.to_json, headers: {})

    @cemetery = FactoryBot.create(:cemetery)
    @cemetery.cemetery_locations << CemeteryLocation.new(latitude: 42.6547541, longitude: -73.7592342)
    @trustee = FactoryBot.create(:trustee)
  end

  scenario 'Investigator begins inspection', js: true do
    login
    visit inspections_cemetery_path(@cemetery)

    click_button 'Begin inspection'
    within('#bracegirdle-confirmation-modal') do
      click_button 'Begin Inspection'
    end
    visit inspections_cemetery_path(@cemetery)

    expect(page).to have_content 'Chester Butkiewicz'
  end
  
  scenario 'Beginning an inspection when one has already been started does not create another one', js: true do
    @inspection = FactoryBot.create(:cemetery_inspection)
    login
    visit inspections_cemetery_path(@cemetery)

    click_button 'Begin inspection'
    
    expect {
      within('#bracegirdle-confirmation-modal') do
        click_button 'Begin Inspection'
      end
    }.not_to change { CemeteryInspection.count }
  end

  scenario 'Investigator uploads legacy inspection', js: true do
    login

    visit inspections_cemetery_path(@cemetery)
    click_link 'Upload inspection'
    attach_file 'cemetery_inspection_inspection_report', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    choices 'Chester Butkiewicz', from: 'Performed By'
    fill_in 'Date Performed', with: '5/6/2015'
    click_button 'Upload Inspection'
    visit inspections_cemetery_path(@cemetery)

    expect(page).to have_content 'May 6, 2015'
  end

  scenario 'Investigator cannot upload old inspection without valid data', js: true do
    login

    visit inspections_cemetery_path(@cemetery)
    click_link 'Upload inspection'
    choices 'Chester Butkiewicz', from: 'Performed By'
    fill_in 'Date Performed', with: '5/6/2015'
    click_button 'Upload Inspection'

    expect(page).to have_content 'There was a problem'
  end

  scenario 'Investigator performs inspection', js: true do
    login
    @trustee = FactoryBot.create(:trustee)
    @inspection = FactoryBot.create(:cemetery_inspection)

    visit inspect_cemetery_path(@cemetery)
    click_button 'Next'
    assert_selector '#cemetery_inspection-physical-characteristics'
    click_button 'Next'
    assert_selector '#cemetery_inspection-record-keeping'
    click_button 'Next'
    assert_selector '#cemetery_inspection-additional-information'
    click_button 'Complete Inspection'
    within '#bracegirdle-confirmation-modal' do
      click_button 'Complete Inspection'
    end
    assert_selector '#cemetery_inspection-detail'
    visit inspections_cemetery_path(@cemetery)

    expect(page).to have_content 'Performed'
  end

  scenario 'Investigator can add attachment to inspection', js: true do
    login
    @trustee = FactoryBot.create(:trustee)
    @inspection = FactoryBot.create(:cemetery_inspection)

    visit inspect_cemetery_path(@cemetery)
    click_button 'Next'
    assert_selector '#cemetery_inspection-physical-characteristics'
    click_button 'Next'
    assert_selector '#cemetery_inspection-record-keeping'
    click_button 'Next'
    assert_selector '#cemetery_inspection-additional-information'
    click_button 'Complete Inspection'
    within '#bracegirdle-confirmation-modal' do
      click_button 'Complete Inspection'
    end
    assert_selector '#cemetery_inspection-detail'
    attach_file 'attachment_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    fill_in 'attachment[description]', with: 'Adding an attachment to this inspection'
    click_button 'Upload'

    expect(page).to have_content 'Adding an attachment to this inspection'
  end
=begin
  scenario 'Investigator creates new trustee during inspection', js: true do
    login
    @inspection = FactoryBot.create(:cemetery_inspection)

    visit inspect_cemetery_path(@cemetery)
    select2 'Mark Smith', from: 'Interviewee', tag: true
    select2 'Treasurer', from: 'Position'
    fill_in 'Address', with: '123 Main St.'
    fill_in 'City', with: 'Deposit'
    select2 'NY', from: 'State'
    fill_in 'ZIP Code', with: '12345'
    click_on 'Next'
    click_on 'Next'
    click_on 'Next'
    click_on 'Complete Inspection'
    assert_selector '#show-inspection'
    visit trustees_cemetery_path(@cemetery)

    expect(page).to have_content 'Mark Smith'
  end
=end
  scenario 'Investigator can finalize inspection', js: true do
    login
    @inspection = FactoryBot.create(:cemetery_inspection)

    visit inspect_cemetery_path(@cemetery)
    click_button 'Next'
    assert_selector '#cemetery_inspection-physical-characteristics'
    click_button 'Next'
    assert_selector '#cemetery_inspection-record-keeping'
    click_button 'Next'
    assert_selector '#cemetery_inspection-additional-information'
    click_button 'Complete Inspection'
    within '#bracegirdle-confirmation-modal' do
      click_button 'Complete Inspection'
    end
    assert_selector '#cemetery_inspection-detail'
    click_button 'Finalize inspection'
    within '#bracegirdle-confirmation-modal' do
      click_button 'Finalize Inspection'
    end
    assert_selector '#cemetery_inspection-download-package-modal'
    visit inspections_cemetery_path(@cemetery)

    expect(page).to have_content 'Completed'
  end

  scenario 'Investigator can revise inspection', js: true do
    @inspection = FactoryBot.create(:cemetery_inspection)
    login

    visit inspect_cemetery_path(@cemetery)
    click_button 'Next'
    assert_selector '#cemetery_inspection-physical-characteristics'
    click_button 'Next'
    assert_selector '#cemetery_inspection-record-keeping'
    click_button 'Next'
    assert_selector '#cemetery_inspection-additional-information'
    click_button 'Complete Inspection'
    within '#bracegirdle-confirmation-modal' do
      click_button 'Complete Inspection'
    end
    assert_selector '#cemetery_inspection-detail'
    click_button 'Revise inspection'
    within '#bracegirdle-confirmation-modal' do
      click_button 'Revise Inspection'
    end
    assert_selector '#cemetery_inspection-perform'
    visit inspections_cemetery_path(@cemetery)

    expect(page).to have_content 'In progress'
  end

  scenario 'Investigator can view inspection package' do
    @inspection = FactoryBot.create(:completed_inspection)
    login

    visit view_full_inspection_package_cemetery_path(@cemetery, @inspection)

    expect(page.status_code).to be 200
  end

  scenario 'Investigator can view inspection package with no violations' do
    @inspection = FactoryBot.create(:no_violation_inspection)
    login

    visit view_full_inspection_package_cemetery_path(@cemetery, @inspection)

    expect(page.status_code).to be 200
  end

  scenario 'Investigator can view incomplete inspections' do
    @inspection = FactoryBot.create(:cemetery_inspection)
    login

    visit incomplete_cemetery_inspections_path

    expect(page).to have_content 'Anthony Cemetery'
  end
end
