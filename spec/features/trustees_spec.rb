require 'rails_helper'

feature 'Trustees' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
  end

  scenario 'User can add trustee', js: true do
    login

    visit cemetery_path(@cemetery)
    click_on 'Trustees'
    click_on 'Add new trustee'
    fill_in 'Name', with: 'Mark Smith'
    select2 'Treasurer', from: 'Position'
    fill_in 'Street address', with: '123 Main St.'
    fill_in 'City', with: 'Deposit'
    select2 'NY', from: 'State'
    fill_in 'ZIP Code', with: '12345'

    expect {
      click_on 'Add New Trustee'
      assert_selector '#trustee-1'
    }.to change(@cemetery.trustees, :count).by(1)
    expect(page).to have_content('Mark Smith')
  end

  scenario 'User can update trustee', js: true do
    FactoryBot.create(:trustee)
    login

    visit cemetery_path(@cemetery)
    click_on 'Trustees'
    click_on 'edit-trustee-1'
    fill_in 'Street address', with: '123 Dolphin Rd.'
    click_on 'Edit Trustee'
    wait_for_ajax

    expect(page).to have_content '123 Dolphin Rd.'
  end
end