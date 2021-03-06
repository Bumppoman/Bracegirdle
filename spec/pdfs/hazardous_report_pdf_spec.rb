require 'rails_helper'

feature 'Hazardous Report PDF' do
  before :each do
    @user = FactoryBot.create(:user)
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
  end

  scenario 'The report is properly displayed' do
    @restoration = FactoryBot.create(:reviewed_hazardous)
    @report = Reports::HazardousReportPDF.new({
      writer: @restoration.investigator,
      cemetery: @restoration.cemetery,
      restoration: @restoration,
      report_date: Date.current
    })
    analysis = PDF::Inspector::Text.analyze(@report.render)

    expect(analysis.strings).to include('  Anthony Cemetery, #04-001')
  end

  scenario 'A report with differing warranties generates properly' do
    @restoration = FactoryBot.create(:reviewed_hazardous)
    @restoration.estimates.first.update(warranty: 10)
    @report = Reports::HazardousReportPDF.new({
      writer: @restoration.investigator,
      cemetery: @restoration.cemetery,
      restoration: @restoration,
      report_date: Date.current
    })
    analysis = PDF::Inspector::Text.analyze(@report.render)

    expect(analysis.strings).to include('  Anthony Cemetery, #04-001')
  end

  scenario 'A report with three estimates generates properly' do
    @restoration = FactoryBot.create(:hazardous_three_estimates)
    @report = Reports::HazardousReportPDF.new({
      writer: @restoration.investigator,
      cemetery: @restoration.cemetery,
      restoration: @restoration,
      report_date: Date.current
    })
    analysis = PDF::Inspector::Text.analyze(@report.render)

    expect(analysis.strings).to include('  Anthony Cemetery, #04-001')
  end
end
