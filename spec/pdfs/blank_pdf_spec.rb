require 'rails_helper'

feature 'Blank PDF' do
  scenario 'A blank PDF is created' do
    sheet = BlankPdf.new({}).render
    analysis = PDF::Inspector::Text.analyze(sheet)

    expect(analysis.strings).to eq []
  end
end