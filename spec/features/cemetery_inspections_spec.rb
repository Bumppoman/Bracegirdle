require 'rails_helper'

feature 'Cemetery Inspections' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery,
      name: 'Anthony Cemetery',
      county: 4,
      order_id: 1
    )
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

  scenario 'Investigator performs inspection', js: true do
    login
    @inspection = FactoryBot.create(:cemetery_inspection)
    @inspection.save
    visit inspect_cemetery_path(@cemetery)

    click_on 'Next'
    click_on 'Next'
    click_on 'Complete Inspection'
    visit inspections_cemetery_path(@cemetery)

    expect(page).to have_content 'Performed'
  end
end