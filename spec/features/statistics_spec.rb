require 'rails_helper'

feature 'Statistics' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
  end

  scenario 'Display investigator statistics' do
    login
    @closed_complaint = FactoryBot.create(:closed_complaint, receiver_id: 1, closure_date: '2019-05-21')
    @brand_new_complaint = FactoryBot.create(:brand_new_complaint)
    @inspection = FactoryBot.create(:completed_inspection, date_performed: '2019-05-11', date_mailed: '2019-05-14')
    @rules = FactoryBot.create(:approved_rules, approval_date: '2019-05-22')

    visit statistics_investigator_path

    expect(page).to have_http_status 200
  end
end