require 'rails_helper'

feature 'Letter PDF' do
  before :each do
    @letter = Letters::LetterPdf.new({
      date: Date.current,
      recipient: 'Andrew Hickey',
      address_line_one: '223 Owego St.',
      address_line_two: 'Owego, NY 13456',
      cemetery: FactoryBot.create(:cemetery),
      name: 'Chester Butkiewicz',
      title: 'Assistant Director',
      signature: 'test.jpg'
    })
  end

  scenario 'The letter is properly displayed' do
    analysis = PDF::Inspector::Text.analyze(@letter.render)

    expect(analysis.strings).to include('Andrew Hickey')
    expect(analysis.strings).to include('Chester Butkiewicz')
    expect(analysis.strings).to include('Division of Cemeteries')
  end
end