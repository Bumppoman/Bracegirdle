require 'rails_helper'

feature 'Rules Approval PDF' do
  before :each do
    @letter = Letters::RulesApprovalPDF.new({
      approval_date: Date.current.to_s,
      cemetery_name: 'Anthony Cemetery',
      address_line_one: '123 Main St.',
      address_line_two: 'Deposit, NY 13444',
      cemetery_number: '04-001',
      submission_date: (Date.current - 21.days).to_s,
      name: 'Chester Butkiewicz',
      title: 'Assistant Director',
    }, date: :approval_date, recipient: :cemetery_name)
  end

  scenario 'The letter is properly displayed' do
    analysis = PDF::Inspector::Text.analyze(@letter.render)

    expect(analysis.strings).to include('Anthony Cemetery')
    expect(analysis.strings).to include('Chester Butkiewicz')
    expect(analysis.strings).to include('Division of Cemeteries')
  end
end
