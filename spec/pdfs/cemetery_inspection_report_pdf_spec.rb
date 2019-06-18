require 'rails_helper'

feature 'Cemetery Inspection Report PDF' do
  before :each do
    FileUtils.cp(Rails.root.join('spec', 'support', 'test.jpg'), Rails.root.join('app', 'pdfs', 'signatures', 'test.jpg'))
    @cemetery = FactoryBot.create(:cemetery)
    @cemetery.save
    @inspection = FactoryBot.create(:cemetery_inspection)
    @package = CemeteryInspectionReportPdf.new({ inspection: @inspection, signature: 'test.jpg' })
  end

  scenario 'The package is properly displayed' do
    analysis = PDF::Inspector::Text.analyze(@package.render)

    expect(analysis.strings).to include('Anthony Cemetery')
  end

  after :each do
    FileUtils.rm(Rails.root.join('app', 'pdfs', 'signatures', 'test.jpg'))
  end
end