require 'rails_helper'

def create_notice
  @investigator = User.new(office_code: 'XXX')

  Notice.new(
    cemetery: FactoryBot.build(:cemetery),
    investigator: @investigator,
    served_on_name: 'John Doe',
    served_on_title: 'President',
    served_on_street_address: '123 Fake St.',
    served_on_city: 'Testing',
    served_on_state: 'NY',
    served_on_zip: '12345',
    law_sections: 'Section 1512. Rights of Lot Owners',
    specific_information: 'Testing.',
    violation_date: Date.current,
    response_required_date: Date.current
  )
end

describe Notice, type: :model do
  subject { create_notice }

  describe 'Actions' do
    describe Notice, '#after_commit' do
      it 'sets a notice number after saving' do
        subject.save

        expect(subject.notice_number).to eq "XXX-#{Date.current.year}-#{'%04i' % subject.id}"
      end
    end
  end

  describe 'Associations' do
    it { should belong_to(:investigator) }
    it { should belong_to(:cemetery) }
  end

  describe 'Instance Methods' do
    describe Notice, '#active?' do
      it 'returns true when the notice is active' do
        expect(subject.active?).to be true
      end

      it 'returns false when the notice is not active' do
        subject.status = :resolved

        expect(subject.active?).to be false
      end
    end

    describe Notice, '#belongs_to?' do
      it 'returns true when the notice belongs to the user' do
        expect(subject.belongs_to?(@investigator)).to be true
      end

      it 'returns false when the notice does not belong to the user' do
        expect(subject.belongs_to?(User.new)).to be false
      end
    end

    describe Notice, '#concern_text' do
      it 'provides the correct text' do
        subject.save
        expect(subject.concern_text).to eq ['Notice of Non-Compliance', "#XXX-#{Date.current.year}-0001", 'against Anthony Cemetery']
      end
    end

    describe Notice, '#formatted_status' do
      it 'returns closed when the notice is closed' do
        subject.status = :resolved

        expect(subject.formatted_status).to eq 'Notice Resolved'
      end
    end

    describe Notice, '#response_required_status' do
      it 'returns 3 days remaining' do
        subject.response_required_date = Date.current + 3

        expect(subject.response_required_status).to eq '3 days remaining'
      end

      it 'returns due today' do
        expect(subject.response_required_status).to eq 'due today'
      end

      it 'returns 3 days overdue' do
        subject.response_required_date = Date.current - 3

        expect(subject.response_required_status).to eq '3 days overdue'
      end
    end
  end

  describe 'Scopes' do
    before :each do
      @active = create_notice
      @active.save
    end

    describe Notice, '.active' do
      it 'returns only active complaints' do
        resolved = create_notice
        resolved.update(
          response_received_date: Date.current,
          follow_up_inspection_date: Date.current,
          status: :resolved
        )
        resolved.save

        result = Notice.active

        expect(result).to eq [@active]
      end
    end

    describe Notice, '.active_for' do
      it "returns only the user's active notices" do
        him = User.new(password: 'test')
        him.save
        me = User.new(password: 'itsme')
        me.save
        resolved = create_notice
        resolved.update(
            response_received_date: Date.current,
            follow_up_inspection_date: Date.current,
            status: :resolved,
            investigator_id: 1
        )
        resolved.save
        my_active = create_notice
        my_active.investigator_id = 2
        my_active.save
        my_resolved = create_notice
        my_resolved.update(
            response_received_date: Date.current,
            follow_up_inspection_date: Date.current,
            status: :resolved,
            investigator_id: 2)
        my_resolved.save

        result = Notice.active_for(me)

        expect(result).to eq [my_active]
      end
    end
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without cemetery' do
      subject.cemetery = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without investigator' do
      subject.investigator = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without served_on_name' do
      subject.served_on_name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without served_on_title' do
      subject.served_on_title = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without served_on_street_address' do
      subject.served_on_street_address = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without served_on_city' do
      subject.served_on_city = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without served_on_state' do
      subject.served_on_state = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without served_on_zip' do
      subject.served_on_zip = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without law sections' do
      subject.law_sections = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without specific information' do
      subject.specific_information = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without the violation date' do
      subject.violation_date = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without the date response is required' do
      subject.response_required_date = nil
      expect(subject).to_not be_valid
    end
  end
end