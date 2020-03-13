require 'rails_helper'

feature 'Land' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
  end

  scenario 'Land purchase application can be uploaded', js: true do
    login

    visit applications_land_index_path(application_type: :purchase) # Visit is ok because we are not waiting on anything
    click_on 'Upload new application'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    select2 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'land_raw_application_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    select2 'Chester Butkiewicz', from: 'Assign To'
    click_on 'Upload Application'
    click_on 'Dashboard'
    visit applications_land_index_path :purchase
    assert_selector '#application-data-table'

    expect(page).to have_content 'Anthony Cemetery'
  end
end
