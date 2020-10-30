require 'rails_helper'

feature 'Rules' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
  end

  scenario 'Investigator can upload old rules', js: true do
    @location = CemeteryLocation.new(latitude: 41.3144, longitude: -73.8964)
    @cemetery.cemetery_locations << @location
    login
    visit new_rules_path

    choices 'Broome', from: 'County'
    choices '04-001 Anthony Cemetery', from: 'Cemetery'
    attach_file 'rules_rules_document', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    choices 'Chester Butkiewicz', from: 'Approved By'
    fill_in 'rules[approval_date]', with: '01/01/2019'
    click_on 'Upload Rules'
    visit cemetery_path(@cemetery)

    expect(page).to have_content 'Approved January 1, 2019'
  end

  scenario 'Investigator cannot upload old rules without selecting the cemetery', js: true do
    @location = CemeteryLocation.new(latitude: 41.3144, longitude: -73.8964)
    @cemetery.cemetery_locations << @location
    login
    visit new_rules_path

    choices 'Broome', from: 'County'
    attach_file 'rules_rules_document', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    choices 'Chester Butkiewicz', from: 'Approved By'
    fill_in 'rules[approval_date]', with: '01/01/2019'
    click_on 'Upload Rules'

    expect(page).to have_content 'There was a problem'
  end
end
