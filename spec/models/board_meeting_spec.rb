require 'rails_helper'

def create_board_meeting
  BoardMeeting.new(
    date: Date.today,
    initial_index: 1
  )
end

describe BoardMeeting, type: :model do
  subject { create_board_meeting }

  context BoardMeeting, 'Instance Methods' do
    context BoardMeeting, 'Instance Methods // Specific Counts' do
      before :each do
        @cemetery = FactoryBot.create(:cemetery)
        @trustee = FactoryBot.create(:trustee)
        @hazardous = FactoryBot.create(:reviewed_hazardous)
        @hazardous_matter = FactoryBot.create(:matter, board_application: @hazardous, board_meeting: subject)
        @vandalism = FactoryBot.create(:reviewed_vandalism)
        @vandalism_matter = FactoryBot.create(:matter, board_application: @vandalism, board_meeting: subject)
        @abandonment = FactoryBot.create(:reviewed_abandonment)
        @abandonment_matter = FactoryBot.create(:matter, board_application: @abandonment, board_meeting: subject)
      end

      describe BoardMeeting, '#abandonment_count' do
        it 'returns the correct number of applications' do
          expect(subject.abandonment_count).to eq 1
        end
      end

      describe BoardMeeting, '#hazardous_count' do
        it 'returns the correct number of applications' do
          expect(subject.hazardous_count).to eq 1
        end
      end

      describe BoardMeeting, '#vandalism_count' do
        it 'returns the correct number of applications' do
          expect(subject.vandalism_count).to eq 1
        end
      end
    end

    describe BoardMeeting, '#set_matter_identifiers' do
      before :each do
        @cemetery = FactoryBot.create(:cemetery)
        @trustee = FactoryBot.create(:trustee)
        @land_sale = FactoryBot.create(:land_sale)
        @land_sale_matter = FactoryBot.create(:matter, board_application: @land_sale, board_meeting: subject)
      end

      it 'correctly sets the matter identifiers' do
        subject.set_matter_identifiers
        expect(subject.matters[0].identifier).to eq "#{subject.date.strftime('%Y–%m')}–E–05"
      end
    end

    describe BoardMeeting, '#to_s' do
      it 'returns the month and year of the board meeting' do
        expect(subject.to_s).to eq Date.today.strftime('%B %Y')
      end
    end
  end
end
