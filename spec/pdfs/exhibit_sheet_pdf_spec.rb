require 'rails_helper'

feature 'Exhibit Sheet PDF' do
  scenario 'The correct exhibit sheet is displayed' do
    sheet = ExhibitSheetPDF.new({ exhibit: 'B' }).render
    analysis = PDF::Inspector::Text.analyze(sheet)

    expect(analysis.strings).to include('Exhibit B')
  end
end
