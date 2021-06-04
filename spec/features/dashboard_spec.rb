require 'rails_helper'

feature 'Dashboard' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)

  end

  scenario 'Performing a search with the cemetery ID' do
    login

    visit root_path
    fill_in 'search', with: '04001'
    click_button 'search-button'

    expect(page).to have_content 'Anthony Cemetery'
  end
  
  scenario 'Performing a search with the hyphenated cemetery ID' do
    login

    visit root_path
    fill_in 'search', with: '04-001'
    click_button 'search-button'

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'Performing a search by name' do
    login

    visit root_path
    fill_in 'search', with: 'anthony'
    click_button 'search-button'

    expect(page).to have_content 'Anthony Cemetery'
  end
  
  scenario 'Performing a search for nonexistant cemetery returns no results', js: true do
    login
    
    visit root_path
    fill_in 'search', with: 'butternuts'
    click_button 'search-button'
    
    expect(page).not_to have_content 'Anthony Cemetery'
    expect(page).to have_content 'There are no results to display.'
  end
end