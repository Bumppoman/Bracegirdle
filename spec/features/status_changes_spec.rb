require 'rails_helper'

feature 'Status Changes' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery,
      name: 'Anthony Cemetery',
      county: 4,
      order_id: 1
    )
  end

  scenario 'Uploading a hazardous monument application tracks status', js: true do
    @trustee = FactoryBot.create(:trustee)
    @cemetery.trustees << @trustee
    @cemetery.save
    login
    visit root_path
    click_on 'Applications'
    click_on 'Hazardous Monuments'
    click_on 'Upload new application'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    select2 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'restoration_raw_application_file', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false

    expect {
      click_on 'Upload Application'
      sleep(0.5)
    }.to change { StatusChange.count }
  end
end