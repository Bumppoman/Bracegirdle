require 'rails_helper'

feature 'Land' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
  end

  scenario 'Land purchase application can be uploaded', js: true do
    login
    
    visit board_applications_land_index_path(application_type: :purchase)
    click_on 'Upload new application'
    choices 'Broome', from: 'County'
    choices '#04-001 Anthony Cemetery', from: 'Cemetery'
    choices 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'land_raw_application_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    choices 'Chester Butkiewicz', from: 'Assign To'
    click_on 'Upload Application'
    click_on 'Dashboard'
    click_on 'Applications'
    click_on 'Land Purchase'

    expect(page).to have_content 'Anthony Cemetery'
  end
end
