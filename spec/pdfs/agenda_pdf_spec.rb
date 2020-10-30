require 'rails_helper'

feature 'Agenda PDF' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @board_meeting = FactoryBot.create(:board_meeting, date: Date.today, status: :agenda_finalized)
    @trustee = FactoryBot.create(:trustee)
    @restoration = FactoryBot.create(:evaluated_hazardous)
    @restoration_matter = FactoryBot.create(:matter, board_meeting: @board_meeting, board_application: @restoration)
    18.times do
      @land_sale = FactoryBot.create(:land_sale)
      @land_sale_matter = FactoryBot.create(:matter, board_meeting: @board_meeting, board_application: @land_sale)
    end
    @board_meeting.set_matter_identifiers
    @agenda = AgendaPDF.new(@board_meeting)
  end

  scenario 'The package is properly displayed' do
    analysis = PDF::Inspector::Text.analyze(@agenda.render)

    expect(analysis.strings).to include('Anthony Cemetery')
  end
end
