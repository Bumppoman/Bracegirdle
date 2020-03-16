require 'rails_helper'

feature 'Cemetery Inspection Items PDF' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @inspection = FactoryBot.create(:cemetery_inspection)
    @package = CemeteryInspectionItemsPDF.new({ inspection: @inspection })
  end

  scenario 'The package is properly displayed' do
    analysis = PDF::Inspector::Text.analyze(@package.render)

    expect(analysis.strings).to include('Items for Consideration')
  end
end
