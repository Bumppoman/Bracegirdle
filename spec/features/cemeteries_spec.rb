require 'rails_helper'

feature 'Cemeteries' do
  before :each do
    @town = Town.new(
      name: 'Sanford',
      county: 4
    )
    @town.save
  end

  scenario 'Add new cemetery', js: true do
    login
    visit new_cemetery_path

    fill_in 'Name', with: 'Anthony Cemetery'
    select2 'Broome', from: 'County'
    fill_in 'Order ID', with: 1
    fill_in 'Location', with: '41.3144, -73.8964'
    select2 'Sanford', from: 'Towns'

    expect {
      click_on 'Submit'
    }.to change { Cemetery.count }
  end
end