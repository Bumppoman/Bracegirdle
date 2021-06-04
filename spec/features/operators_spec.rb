require 'rails_helper'

feature 'Operators' do
  before :each do
    @crematory = FactoryBot.create(:crematory)
  end
  
  scenario 'Can add operator to crematory', js: true do
    login
    
    visit crematory_path(@crematory)
    find('a', text: 'Operators').click
    click_button 'Add New Operator'
    within '#operators-form-modal' do
      fill_in 'Name', with: 'Joseph Ambrose'
      fill_in 'Certification Date', with: '10/08/2020'
      fill_in 'Certification Expiration Date', with: '12/31/2025'
      click_button 'Add New Operator'
    end
    assert_selector '.disappearing-success-message'
    
    expect(page).to have_content 'Joseph Ambrose'
  end
  
  scenario 'Can edit operator', js: true do
    @operator = FactoryBot.create(:operator)
    login

    visit crematory_path(@crematory)
    find('a', text: 'Operators').click
    find("a[data-action='operators--index#editOperator'][data-operator-id='#{@operator.id}']").click
    within '#operators-form-modal' do
      fill_in 'Name', with: 'Michael Seelman'
      click_button 'Edit Operator'
    end
    assert_selector '.disappearing-success-message'
    
    expect(page).to have_content 'Michael Seelman'
  end
end