require 'rails_helper'

def create_rules
  Rules.new(
    cemetery: Cemetery.new(county: 4),
    submission_date: Date.current,
    sender: 'Bill Cemeterian',
    sender_street_address: '123 Fake St.',
    sender_city: 'Rochester',
    sender_state: 'NY',
    sender_zip: '14677',
    request_by_email: false
  )
end

describe Rules, type: :model do
  subject { create_rules }

  describe 'Actions' do
    describe Rules, '#after_commit' do
      it 'sets an identifier after saving' do
        subject.save

        expect(subject.identifier).to eq "#{subject.created_at.year}-#{'%04d' % subject.id}"
      end
    end
  end

  describe 'Associations' do
    it { should belong_to(:cemetery) }
  end

  describe 'Instance Methods' do
    describe Rules, '#approved?' do
      it 'returns approved if the rules are approved' do
        subject.status = :approved

        expect(subject.approved?).to be true
      end

      it 'returns false if the rules are not approved' do
        expect(subject.approved?).to be false
      end
    end

    describe Rules, '#approver' do
      it 'returns unknown if there is no approver' do
        expect(subject.approver).to eq 'Unknown'
      end

      it 'returns the name of the approver if the rules are approved' do
        subject.approved_by = User.new(name: 'Mel Spivey')

        expect(subject.approver).to eq 'Mel Spivey'
      end
    end

    describe Rules, '#named_status' do
      it 'returns the correct status' do
        expect(subject.named_status).to eq 'Pending Review'
      end
    end

    describe Rules, '#status=' do
      it 'accepts a valid symbol for status' do
        subject.status = :approved

        expect(subject.status).to eq 3
      end

      it 'accepts a number for status' do
        subject.status = 2

        expect(subject.status).to eq 2
      end
    end
  end

  describe 'Scopes' do
    before :each do
      @active = create_rules
      @active.save
    end

    describe Rules, '.active_for' do
      it "returns only the user's active rules" do
        approved = create_rules
        approved.update(
            status: :approved,
            approval_date: Date.current,
            approved_by_id: 1)
        my_active = create_rules
        my_active.cemetery = Cemetery.new(county: 6)
        my_active.status = :revision_requested
        my_active.save
        my_approved = create_rules
        my_approved.update(
            cemetery: Cemetery.new(county: 6),
            status: :approved,
            approval_date: Date.current,
            approved_by_id: 2)
        him = User.new(password: 'test', region: 5)
        him.save
        me = User.new(password: 'itsme', region: 4)
        me.save

        result = Rules.active_for(me)

        expect(result).to eq [my_active]
      end
    end

    describe Rules, '.approved' do
      it 'returns only approved rules' do
        approved = create_rules
        approved.update(
            status: :approved,
            approval_date: Date.current,
            approved_by_id: 1)
        my_active = create_rules
        my_active.save

        result = Rules.approved

        expect(result).to eq [approved]
      end
    end

    describe Rules, '.pending_review_for' do
      it "returns only the user's rules pending review" do
        approved = create_rules
        approved.update(
            status: :approved,
            approval_date: Date.current,
            approved_by_id: 1)
        my_active = create_rules
        my_active.cemetery = Cemetery.new(county: 6)
        my_active.save
        my_approved = create_rules
        my_approved.update(
            cemetery: Cemetery.new(county: 6),
            status: :approved,
            approval_date: Date.current,
            approved_by_id: 2)
        him = User.new(password: 'test', region: 5)
        him.save
        me = User.new(password: 'itsme', region: 4)
        me.save

        result = Rules.pending_review_for(me)

        expect(result).to eq [my_active]
      end
    end
  end
end