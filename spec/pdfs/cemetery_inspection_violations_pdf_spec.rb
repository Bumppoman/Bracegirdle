require 'rails_helper'

feature 'Cemetery Inspection Violations PDF' do
  before :each do
    @letter = Letters::CemeteryInspectionViolationsPdf.new(
      {
          date: Date.current,
          recipient: 'Anthony Cemetery',
          address_line_one: '123 Main St.',
          address_line_two: 'Deposit, NY 13455',
          cemetery: Cemetery.new(name: 'Anthony Cemetery', county: 4, order_id: 1),
          name: 'Chester Butkiewicz',
          title: 'Assistant Director',
      }
    )
  end

  scenario 'The letter is properly displayed' do
    analysis = PDF::Inspector::Text.analyze(@letter.render)

    expect(analysis.strings).to include('Anthony Cemetery')
    expect(analysis.strings).to include('Chester Butkiewicz')
    expect(analysis.strings).to include('Division of Cemeteries')
  end
end