require 'rails_helper'

feature 'Dashboard' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery,
      name: 'Anthony Cemetery',
      county: 4,
      order_id: 1
    )
    @cemetery.save
  end

  scenario 'Performing a search with the cemetery ID' do
    login

    visit root_path
    fill_in 'search', with: '04001'
    click_on 'search-button'

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'Performing a search by name' do
    login

    visit root_path
    fill_in 'search', with: 'anthony'
    click_on 'search-button'

    expect(page).to have_content 'Anthony Cemetery'
  end
end