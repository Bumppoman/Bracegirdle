require 'rails_helper'
require 'byebug'

feature 'Contractors' do
  before :each do
    @contractor = FactoryBot.create(:contractor)
  end
  
  scenario 'List all active contractors' do
    login
    
    visit board_applications_restorations_contractors_path
    
    expect(page).to have_content 'Rocky Stone Monuments'
  end
  
  scenario 'New contractor can be added', js: true do
    login
    
    visit board_applications_restorations_contractors_path
    click_button 'Add New Contractor'
    within '#board_applications-restorations-contractors-form-modal' do
      fill_in 'Name', with: 'Stony Curtis Monuments'
      fill_in 'Street Address', with: '123 Rock St.'
      fill_in 'City', with: 'Philadelphia'
      choices 'PA', from: 'State'
      fill_in 'ZIP Code', with: '12345'
      choices 'Broome', from: 'County'
      click_button 'Add New Contractor'
    end
    assert_selector '.disappearing-success-message'
    
    expect(page).to have_content 'Stony Curtis Monuments'
  end
  
  scenario 'Contractor can be edited', js: true do
    login
    
    visit board_applications_restorations_contractors_path
    find('[data-action="board-applications--restorations--contractors--index#openEditContractorForm"]').click
    within '#board_applications-restorations-contractors-form-modal' do
      fill_in 'Name', with: 'Stony Curtis Monuments'
      click_button 'Edit Contractor'
    end
    assert_selector '.disappearing-success-message'
    
    expect(page).to have_content 'Stony Curtis Monuments'
  end
end