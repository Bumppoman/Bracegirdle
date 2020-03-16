require 'rails_helper'

feature 'Investigator Statistics Report PDF' do
  scenario 'The investigator statistics report is created' do
    sheet = InvestigatorStatisticsReportPDF.new({
      investigator: FactoryBot.create(:user),
      month: 5,
      year: 2019,
      month_name: 'May'
    }).render
    analysis = PDF::Inspector::Text.analyze(sheet)

    expect(analysis.strings).to include 'Investigator Statistics'
  end
end
