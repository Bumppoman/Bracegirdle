require 'rails_helper'

feature 'Trustees' do
  before :each do
    stub_request(:get, /nominatim.openstreetmap.org/)
    .with(
      headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Ruby'
      }
    )
    .to_return(status: 200, body: {}.to_json, headers: {})

    @cemetery = FactoryBot.create(:cemetery)
  end

  scenario 'User can add trustee', js: true do
    login

    visit cemetery_path(@cemetery)
    click_on 'Trustees'
    click_on 'Add New Trustee'
    fill_in 'Name', with: 'Mark Smith'
    choices 'Treasurer', from: 'Position'
    fill_in 'Street address', with: '123 Main St.'
    fill_in 'City', with: 'Deposit'
    choices 'NY', from: 'State'
    fill_in 'ZIP Code', with: '12345'

    expect {
      within '#trustee-form-modal' do
        click_button 'Add New Trustee'
      end
      assert_no_selector '#trustee-form-modal'
    }.to change(@cemetery.trustees, :count).by(1)
    expect(page).to have_content('Mark Smith')
  end

  scenario 'User can update trustee', js: true do
    @trustee = FactoryBot.create(:trustee)
    login

    visit cemetery_path(@cemetery)
    click_on 'Trustees'
    find("a[data-trustee-id='#{@trustee.id}']").click
    within '#trustee-form-modal' do
      fill_in 'Street address', with: '123 Dolphin Rd.'
      click_on 'Edit Trustee'
    end
    assert_no_selector '#trustee-form-modal'

    expect(page).to have_content '123 Dolphin Rd.'
  end
end
