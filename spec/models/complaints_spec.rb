require 'rails_helper'

def create_complaint
  Complaint.new(
      receiver: User.new,
      complainant_name: 'Chester Butkiewicz',
      complaint_type: '1, 5, 6',
      summary: 'Testing.',
      form_of_relief: 'Testing.',
      date_of_event: Date.current,
      cemetery: Cemetery.new(name: 'Anthony Cemetery'))
end

describe Complaint, type: :model do
  subject { create_complaint }

  describe 'Actions' do
    describe Complaint, '#after_commit' do
      it 'sets a complaint number after saving' do
        subject.save

        expect(subject.complaint_number).to eq "#{subject.created_at.year}-#{'%04d' % subject.id}"
      end
    end
  end

  describe 'Associations' do
    it { should belong_to(:investigator) }
    it { should belong_to(:cemetery) }
    it { should belong_to(:receiver) }
  end

  describe 'Instance Methods' do
    describe Complaint, '#belongs_to?' do
      it 'returns true when the complaint belongs to the user' do
        @investigator = User.new(password: 'test')
        subject.investigator = @investigator

        expect(subject.belongs_to?(@investigator)).to be true
      end

      it 'returns false when the complaint does not belong to the user' do
        expect(subject.belongs_to?(User.new)).to be false
      end
    end

    describe Complaint, '#cemetery_contact' do
      it 'returns the default message when there is no info' do
        expect(subject.cemetery_contact).to eq 'No cemetery contact information provided'
      end

      it 'returns just the name if there is a person contacted' do
        subject.person_contacted = 'John Smith'

        expect(subject.cemetery_contact).to eq 'John Smith'
      end

      it 'returns the name and the method if both are provided' do
        subject.person_contacted = 'John Smith'
        subject.manner_of_contact = '1, 3'

        expect(subject.cemetery_contact).to eq 'John Smith (by phone, email)'
      end

      it 'returns nothing if the person is empty' do
        subject.manner_of_contact = '1, 3'

        expect(subject.cemetery_contact).to eq 'No cemetery contact information provided'
      end
    end

    describe Complaint, '#closed?' do
      it 'is true when the complaint is closed' do
        subject.status = :closed

        expect(subject.closed?).to eq true
      end

      it 'is false when the complaint is not closed' do
        expect(subject.closed?).to eq false
      end
    end

    describe Complaint, '#complaint_type' do
      it 'splits the string properly' do
        expect(subject.complaint_type).to eq ['1', '5', '6']
      end
    end

    describe Complaint, '#formatted_cemetery' do
      it 'provides the cemetery name if the cemetery is regulated' do
        expect(subject.formatted_cemetery).to eq 'Anthony Cemetery'
      end

      it 'provides the alternate name if the cemetery is not regulated' do
        subject.cemetery_regulated = false
        subject.cemetery_alternate_name = 'Test Cemetery'

        expect(subject.formatted_cemetery).to eq 'Test Cemetery'
      end
    end

    describe Complaint, '#formatted_ownership' do
      it 'returns a blank string if there is no ownership information' do
        expect(subject.formatted_ownership).to eq ''
      end

      it 'returns only the owner if there is no relationship information' do
        subject.name_on_deed = 'Chester Butkiewicz'

        expect(subject.formatted_ownership).to eq 'Owned by Chester Butkiewicz'
      end

      it 'returns the owner and the relationship if both are available' do
        subject.name_on_deed = 'Chester Butkiewicz'
        subject.relationship = 'Father'

        expect(subject.formatted_ownership).to eq 'Owned by Chester Butkiewicz (Father)'
      end

      it 'returns a blank string if there is no owner but is a relationship' do
        subject.relationship = 'Father'

        expect(subject.formatted_ownership).to eq ''
      end
    end

    describe Complaint, '#last_action' do
      it "returns 'Investigation Begun' when status is :investigation_begun" do
        subject.status = :investigation_begun

        expect(subject.last_action).to eq 'Investigation Begun'
      end
    end

    describe Complaint, '#ownership_type_string' do
      it 'returns the ownership type based on the code' do
        subject.ownership_type = 2

        expect(subject.ownership_type_string).to eq 'Inheritance'
      end
    end

    describe Complaint, '#pending_closure?' do
      it 'is true when the complaint is pending closure' do
        subject.status = :pending_closure

        expect(subject.pending_closure?).to eq true
      end

      it 'is false when the complaint is pending closure' do
        expect(subject.pending_closure?).to eq false
      end
    end

    describe Complaint, '#status=' do
      it 'accepts a valid symbol for status' do
        subject.status = :closed

        expect(subject.status).to eq 5
      end

      it 'accepts a number for status' do
        subject.status = 2

        expect(subject.status).to eq 2
      end
    end

    describe Complaint, '#to_s' do
      it 'returns the complaint number' do
        subject.complaint_number = '2019-0001'

        expect(subject.to_s).to eq '2019-0001'
      end
    end

    describe Complaint, '#unassigned?' do
      it 'is true when the complaint is unassigned' do
        expect(subject.unassigned?).to eq true
      end

      it 'is false when the complaint is assigned' do
        subject.investigator = User.new(password: 'test')
        expect(subject.unassigned?).to eq false
      end
    end
  end

  describe 'Scopes' do
    before :each do
      @active = create_complaint
      @active.save
    end

    describe Complaint, '.active' do
      it 'returns only active complaints' do
        closed = create_complaint
        closed.update(
            disposition: 'Testing',
            investigation_begin_date: Date.current,
            investigation_completion_date: Date.current,
            disposition_date: Date.current,
            status: 5)
        closed.save

        result = Complaint.active

        expect(result).to eq [@active]
      end
    end

    describe Complaint, '.active_for' do
      it "returns only the user's active complaints" do
        closed = create_complaint
        closed.update(
            disposition: 'Testing',
            investigation_begin_date: Date.current,
            investigation_completion_date: Date.current,
            disposition_date: Date.current,
            status: :closed,
            investigator_id: 1)
        closed.save
        my_active = create_complaint
        my_active.investigator_id = 2
        my_active.save
        my_closed = create_complaint
        my_closed.update(
            disposition: 'Testing',
            investigation_begin_date: Date.current,
            investigation_completion_date: Date.current,
            disposition_date: Date.current,
            status: :closed,
            investigator_id: 2)
        my_closed.save
        him = User.new(password: 'test')
        him.save
        me = User.new(password: 'itsme')
        me.save

        result = Complaint.active_for(me)

        expect(result).to eq [my_active]
      end
    end

    describe Complaint, '.pending_closure' do
      it 'returns only complaints pending closure' do
        pending_closure = create_complaint
        pending_closure.update(
            disposition: 'Testing',
            investigation_begin_date: Date.current,
            investigation_completion_date: Date.current,
            disposition_date: Date.current,
            status: :pending_closure,
            investigator_id: 2)
        pending_closure.save

        result = Complaint.pending_closure

        expect(result).to eq [pending_closure]
      end
    end

    describe Complaint, '.unassigned' do
      it 'returns only unassigned complaints' do
        assigned = create_complaint
        assigned.investigator = User.new(password: 'test')
        assigned.save

        result = Complaint.unassigned

        expect(result).to eq [@active]
      end
    end
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is valid when the cemetery is not regulated but there is an alternate name' do
      subject.cemetery = nil
      subject.cemetery_regulated = false
      subject.cemetery_alternate_name = 'Test Cemetery'

      expect(subject).to be_valid
    end

    it 'is not valid without a receiver' do
      subject.receiver = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a complainant name' do
      subject.complainant_name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a complaint type' do
      subject.complaint_type = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a summary' do
      subject.summary = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a form of relief' do
      subject.form_of_relief = nil

      expect(subject).to_not be_valid
    end

    it 'is not valid without the date of event' do
      subject.date_of_event = nil

      expect(subject).to_not be_valid
    end

    it 'is not valid without a cemetery' do
      subject.cemetery = nil

      expect(subject).to_not be_valid
    end

    it 'is not valid if the cemetery is not regulated and the name is not filled in' do
      subject.cemetery = nil
      subject.cemetery_regulated = false

      expect(subject).to_not be_valid
    end

    it 'cannot be closed if the disposition is empty' do
      subject.status = :closed
      expect(subject).to_not be_valid
    end
  end
end