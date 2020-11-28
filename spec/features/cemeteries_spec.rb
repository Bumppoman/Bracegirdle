require 'rails_helper'

feature 'Cemeteries' do
  before :each do
    @town = Town.new(
      name: 'Sanford',
      county: 4
    )

    @cemetery_location = CemeteryLocation.new(
      latitude: 41.3144,
      longitude: -73.8964
    )

    @cemetery = FactoryBot.create(
      :cemetery, 
      last_inspection_date: Date.current - 6.years, 
      last_audit_date: Date.current - 4.years
    )
    @cemetery.cemetery_locations << @cemetery_location
    @cemetery.towns << @town
  end

  scenario 'Add new cemetery', js: true do
    @second_town = Town.new(name: 'Lisle', county: 4)
    @second_town.save
    login_supervisor
    visit new_cemetery_path

    fill_in 'Name', with: 'Center Lisle Cemetery'
    choices 'Broome', from: 'County'
    fill_in 'Cemetery ID', with: '04002'
    choices 'Lisle', from: 'Towns'
    fill_in 'Location', with: '42.3144, -74.8964'

    expect {
      click_on 'Add Cemetery'
    }.to change { Cemetery.count }
  end

  scenario 'View cemetery' do
    login

    visit cemetery_path(@cemetery)
  end

  scenario 'Display cemeteries by county' do
    login

    visit county_cemeteries_path(4)

    expect(page).to have_content 'Anthony Cemetery'
  end
  
  scenario 'List all cemeteries' do
    login
    
    visit cemeteries_path
    
    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'List cemeteries by region' do
    login

    visit region_cemeteries_path('binghamton')

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'View overdue inspections for investigator' do
    login

    visit overdue_inspections_cemeteries_path

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'View overdue inspections for region' do
    @syracuse_cemetery = Cemetery.new(
      cemid: '06001',
      name: 'Bird Cemetery',
      county: 6,
      investigator_region: 4,
      last_inspection_date: Date.current - 6.years)
    @syracuse_cemetery.save
    login

    visit overdue_inspections_cemeteries_path(type: :region, region: :syracuse)

    expect(page).to have_content 'Bird Cemetery'
  end
end
