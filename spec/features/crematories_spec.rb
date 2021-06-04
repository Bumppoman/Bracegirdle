require 'rails_helper'

feature 'Crematories' do
  scenario 'Can create new crematory', js: true do
    login
    visit new_crematory_path
    
    fill_in 'Name', with: 'Seelman Brothers Crematory'
    choices 'Oswego', from: 'County'
    fill_in 'Crematory ID', with: '38999'
    fill_in 'Address', with: '1382 State Route 13'
    fill_in 'City', with: 'Pulaski'
    fill_in 'ZIP Code', with: '13842'
    fill_in 'Phone', with: '315-425-4232'
    fill_in 'Email', with: 'seelmanbros@gmail.com'
    choose id: 'crematory_classification_independent'
    click_button 'Add Crematory'
    
    expect(page).to have_content 'Seelman Brothers Crematory'
  end
  
  scenario 'Can view list of crematories' do
    @crematory = FactoryBot.create(:crematory)
    login
    
    visit crematories_path
    
    expect(page).to have_content 'Seelman Brothers Crematory'
  end
end