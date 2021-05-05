require 'rails_helper'

feature 'Notice PDF' do
  before :each do
    @notice = NoticePDF.new(
      {
        'cemetery_name' => 'Anthony Cemetery',
        'cemetery_number' => '04-001',
        'investigator_name' => 'Chester Butkiewicz',
        'investigator_title' => 'Assistant Director',
        'response_street_address' => '99 Washington Avenue',
        'response_city' => 'Albany',
        'response_zip' => '12231',
        'notice_date' => Date.current,
        'secondary_law_sections' => 'Test.',
        'served_on_title' => 'President'
      }
    )
  end

  scenario 'The notice is displayed correctly' do
    analysis = PDF::Inspector::Text.analyze(@notice.render)

    expect(analysis.strings).to include('Chester Butkiewicz')
    expect(analysis.strings).to include('Anthony Cemetery')
  end
end
