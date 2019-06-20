require 'rails_helper'

feature 'Cemetery Inspections' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @cemetery.locations << Location.new(latitude: 42.6547541, longitude: -73.7592342)
  end

  scenario 'Unauthorized user tries to begin inspection' do
    expect { visit inspect_cemetery_path(@cemetery) }.to raise_error(ApplicationController::Forbidden)
  end

  scenario 'Investigator begins inspection', js: true do
    login
    visit inspections_cemetery_path(@cemetery)

    click_on 'Begin inspection'
    within('#confirm-begin-inspection') do
      click_on 'Begin inspection'
    end
    visit inspections_cemetery_path(@cemetery)

    expect(page).to have_content 'Chester Butkiewicz'
  end

  scenario 'Investigator uploads old inspection', js: true do
    login

    visit inspections_cemetery_path(@cemetery)
    click_on 'Upload inspection'
    attach_file 'cemetery_inspection_inspection_report', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    select2 'Chester Butkiewicz', from: 'Performed By'
    fill_in 'Date Performed', with: '5/6/2015'
    click_on 'Submit'
    visit inspections_cemetery_path(@cemetery)

    expect(page).to have_content 'May 6, 2015'
  end

  scenario 'Investigator cannot upload old inspection without valid data', js: true do
    login

    visit inspections_cemetery_path(@cemetery)
    click_on 'Upload inspection'
    attach_file 'cemetery_inspection_inspection_report', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    select2 'Chester Butkiewicz', from: 'Performed By'
    click_on 'Submit'

    expect(page).to have_content 'There was a problem'
  end

  scenario 'Investigator performs inspection', js: true do
    login
    @trustee = FactoryBot.create(:trustee)
    @inspection = FactoryBot.create(:cemetery_inspection)

    visit inspect_cemetery_path(@cemetery)
    click_on 'Next'
    click_on 'Next'
    click_on 'Complete Inspection'
    wait_for_ajax
    visit inspections_cemetery_path(@cemetery)

    expect(page).to have_content 'Performed'
  end

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
    click_on 'Complete Inspection'
    #click_on 'Dashboard', match: :first
    wait_for_ajax
    visit trustees_cemetery_path(@cemetery)

    expect(page).to have_content 'Mark Smith'
  end

  scenario 'Investigator can finalize inspection', js: true do
    login
    @inspection = FactoryBot.create(:cemetery_inspection)

    visit inspect_cemetery_path(@cemetery)
    click_on 'Next'
    click_on 'Next'
    click_on 'Complete Inspection'
    click_on 'Mail inspection', wait: 5
    wait_for_ajax
    visit inspections_cemetery_path(@cemetery)

    expect(page).to have_content 'Complete'
  end

  scenario 'Investigator can revise inspection', js: true do
    @inspection = FactoryBot.create(:cemetery_inspection)
    login

    visit inspect_cemetery_path(@cemetery)
    click_on 'Next'
    click_on 'Next'
    click_on 'Complete Inspection'
    click_on 'Revise inspection'
    assert_selector '#perform-inspection'
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

    visit incomplete_inspections_path

    expect(page).to have_content 'Anthony Cemetery'
  end
end