require 'rails_helper'

feature 'Investigator Statistics Report PDF' do
  scenario 'The investigator statistics report is created' do
    sheet = InvestigatorStatisticsReportPdf.new({ investigator: FactoryBot.create(:user) }).render
    analysis = PDF::Inspector::Text.analyze(sheet)

    expect(analysis.strings).to include 'Investigator Statistics'
  end
end