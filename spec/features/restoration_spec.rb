require 'rails_helper'

feature 'Restoration' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery,
      name: 'Anthony Cemetery',
      county: 4,
      order_id: 1)
  end

  scenario 'Hazardous monument application can be uploaded' do
    login
    visit root_path

    click_on 'Applications'
    click_on 'Hazardous Monuments'
    click_on 'Upload new application'
    #visit vandalism_hazardous_path

    #expect(page).to have_content 'Anthony Cemetery'
  end
end