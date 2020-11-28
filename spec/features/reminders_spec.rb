require 'rails_helper'

feature 'Reminders' do
  scenario 'User can add reminder', js: true do
    login
    
    find('#reminders .header-notification').click
    click_link 'Add Reminder'
    within '#reminders-form-modal' do
      fill_in 'Title', with: 'Call Joseph Ambrose'
      fill_in 'Details', with: 'Give Joe a call'
      click_button 'Create New Reminder'
    end
    assert_selector '[data-target="reminders.reminder"]'
    
    expect(page).to have_content 'Call Joseph Ambrose'
  end
  
  scenario 'User can complete reminder', js: true do
    @user = FactoryBot.create(:user)
    @reminder = FactoryBot.create(:reminder, user: @user)
    login(@user)
    
    find('#reminders .header-notification').click
    find('a[data-confirmation-modal-title="Complete Reminder"]').click
    within '#bracegirdle-confirmation-modal' do
      click_button 'Complete Reminder'
    end
    assert_no_selector '[data-target="reminders.reminder"]'
    
    expect(page).to have_content 'You currently have no reminders'
  end
  
  scenario 'User can cancel reminder', js: true do
    @user = FactoryBot.create(:user)
    @reminder = FactoryBot.create(:reminder, user: @user)
    login(@user)
    
    find('#reminders .header-notification').click
    find('a[data-confirmation-modal-title="Cancel Reminder"]').click
    within '#bracegirdle-confirmation-modal' do
      click_button 'Cancel Reminder'
    end
    assert_no_selector '[data-target="reminders.reminder"]'
    
    expect(page).to have_content 'You currently have no reminders'
  end
end