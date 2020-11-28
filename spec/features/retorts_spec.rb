require 'rails_helper'

feature 'Retorts' do
  before :each do
    @crematory = FactoryBot.create(:crematory)
    @retort_model = FactoryBot.create(:retort_model)
  end
  
  scenario 'Can add new retort to crematory', js: true do
    login
    visit crematory_path(@crematory)
    
    click_on 'Retorts'
    click_button 'Add New Retort'
    within '#retorts-form-modal' do
      choices 'N20AA', from: 'Retort Model'
      fill_in 'Installation Date', with: '01/01/2020'
      click_button 'Add New Retort'
    end
    assert_selector '.disappearing-success-message'
    
    expect(page).to have_content 'B&L N20AA'
  end
  
  scenario 'Can add new retort model while adding retort to crematory', js: true do
    login
    visit crematory_path(@crematory)
    
    click_on 'Retorts'
    click_button 'Add New Retort'
    click_button 'Add Retort Model'
    within '#crematories-retort_models-form-modal' do
      choices 'B&L', from: 'Manufacturer'
      fill_in 'Name', with: 'Phoenix II-1'
      fill_in 'Maximum Throughput', with: '57'
      click_button 'Add New Retort Model'
    end
    within '#retorts-form-modal' do
      fill_in 'Installation Date', with: '01/01/2020'
      click_button 'Add New Retort'
    end
    assert_selector '.disappearing-success-message'
    
    expect(page).to have_content 'Phoenix II-1'
  end
  
  scenario 'Can update retort', js: true do
    @retort = FactoryBot.create(:retort, crematory: @crematory, retort_model: @retort_model) 
    login
    visit crematory_path(@crematory)
    
    click_on 'Retorts'
    find("a[data-action='retorts--index#editRetort'][data-retort-id='#{@retort.id}']").click
    within '#retorts-form-modal' do
      fill_in 'Installation Date', with: '01/01/2020'
      click_button 'Edit Retort'
    end
    assert_selector '.disappearing-success-message'
    
    expect(page).to have_content 'January 1, 2020'
  end
end