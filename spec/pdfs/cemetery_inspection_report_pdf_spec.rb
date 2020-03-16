require 'rails_helper'

feature 'Cemetery Inspection Report PDF' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @cemetery.save
    @inspection = FactoryBot.create(:cemetery_inspection)
    @package = CemeteryInspectionReportPDF.new({ inspection: @inspection, signature: 'test.jpg' })
  end

  scenario 'The package is properly displayed' do
    analysis = PDF::Inspector::Text.analyze(@package.render)

    expect(analysis.strings).to include('Anthony Cemetery')
  end
end
