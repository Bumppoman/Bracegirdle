require 'rails_helper'

feature 'Statistics' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @date = Date.current
  end

  scenario 'Display investigator statistics' do
    login
    @closed_complaint = FactoryBot.create(:closed_complaint, receiver_id: 1)
    StatusChange.create(statable: @closed_complaint, status: 5, created_at: @closed_complaint.created_at)
    @brand_new_complaint = FactoryBot.create(:brand_new_complaint)
    @inspection = FactoryBot.create(:completed_inspection, date_performed: @date, date_mailed: @date)
    @rules = FactoryBot.create(:approved_rules, approval_date: @date)

    visit statistics_investigator_path

    expect(page).to have_http_status 200
  end
end