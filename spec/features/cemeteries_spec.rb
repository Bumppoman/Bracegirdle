require 'rails_helper'

feature 'Cemeteries' do
  before :each do
    @town = Town.new(
      name: 'Sanford',
      county: 4
    )

    @location = Location.new(
      latitude: 41.3144,
      longitude: -73.8964
    )

    @cemetery = FactoryBot.create(:cemetery, last_inspection_date: Date.current - 6.years)
    @cemetery.locations << @location
    @cemetery.towns << @town
  end

  scenario 'Add new cemetery', js: true do
    @second_town = Town.new(name: 'Lisle', county: 4)
    @second_town.save
    login
    visit new_cemetery_path

    fill_in 'Name', with: 'Center Lisle Cemetery'
    select2 'Broome', from: 'County'
    fill_in 'Order ID', with: 2
    fill_in 'Location', with: '42.3144, -74.8964'
    select2 'Lisle', from: 'Towns'

    expect {
      click_on 'Submit'
    }.to change { Cemetery.count }
  end

  scenario 'Display cemeteries by county' do
    login

    visit cemeteries_by_county_path(4)

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'List cemeteries by region' do
    login

    visit cemeteries_by_region_path('binghamton')

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'View overdue inspections for investigator' do
    login

    visit overdue_inspections_cemeteries_path

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'View overdue inspections for region' do
    @syracuse_cemetery = Cemetery.new(
      name: 'Bird Cemetery',
      county: 6,
      order_id: 1,
      investigator_region: 4,
      last_inspection_date: Date.current - 6.years)
    @syracuse_cemetery.save
    login

    visit overdue_inspections_cemeteries_path(region: :syracuse)

    expect(page).to have_content 'Bird Cemetery'
  end
end