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
    request_by_email: false,
    status: Rules::STATUSES[:pending_review]
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
    it { should belong_to :cemetery }
    it { should belong_to :investigator }
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

    describe Rules, '#named_status' do
      it 'returns the correct status' do
        expect(subject.named_status).to eq 'Pending Review'
      end
    end

    describe Rules, '#status=' do
      it 'accepts a valid symbol for status' do
        subject.status = :approved

        expect(subject.status).to eq 4
      end

      it 'accepts a number for status' do
        subject.status = 2

        expect(subject.status).to eq 2
      end
    end

    describe Rules, '#unassigned?' do
      it 'returns true if the rules were not assigned' do
        subject.status = Rules::STATUSES[:received]

        expect(subject.unassigned?).to be true
      end

      it 'returns false if the rules were assigned' do
        expect(subject.unassigned?).to be false
      end
    end
  end

  describe 'Scopes' do
    before :each do
      @me = User.new(password: 'test', role: 2)
      @me.save
      @active = create_rules
      @active.update(investigator_id: 1)
    end

    describe Rules, '.active' do
      it 'returns only active rules' do
        approved = Rules.new(status: Rules::STATUSES[:approved])
        approved.save

        result = Rules.active

        expect(result).to eq [@active]
      end
    end

    describe Rules, '.active_for' do
      before :each do
        @him = User.new(password: 'test', role: 2)
        @him.save
      end

      it 'returns only active rules' do
        approved = create_rules
        approved.update(cemetery: Cemetery.new(county: 4), status: Rules::STATUSES[:approved], investigator_id: 1)
        his_active = create_rules
        his_active.update(cemetery: Cemetery.new(county: 6), investigator_id: 2)

        result = Rules.active_for(@me)

        expect(result).to eq [@active]
      end

      it 'also returns rules that are awaiting revisions' do
        awaiting_revisions = create_rules
        awaiting_revisions.update(status: Rules::STATUSES[:revision_requested], investigator_id: 1)

        result = Rules.active_for(@me)

        expect(result).to eq [@active, awaiting_revisions]
      end
    end

    describe Rules, '.approved' do
      it 'returns only approved rules' do
        approved = create_rules
        approved.update(
            status: :approved,
            approval_date: Date.current)
        my_active = create_rules
        my_active.save

        result = Rules.approved

        expect(result).to eq [approved]
      end
    end

    describe Rules, '.pending_review_for' do
      before :each do
        @him = User.new(password: 'test')
        @him.save
      end

      it 'returns only rules pending review' do
        approved = create_rules
        approved.update(cemetery: Cemetery.new(county: 4), status: Rules::STATUSES[:approved], investigator_id: 1)
        his_active = create_rules
        his_active.update(cemetery: Cemetery.new(county: 6), investigator_id: 2)

        result = Rules.pending_review_for(@me)

        expect(result).to eq [@active]
      end

      it "doesn't return rules that are awaiting revision" do
        awaiting_revisions = create_rules
        awaiting_revisions.update(status: Rules::STATUSES[:revision_requested])

        result = Rules.pending_review_for(@me)

        expect(result).to eq [@active]
      end
    end

    describe Rules, '.unassigned' do
      it 'returns only unassigned rules' do
        unassigned = create_rules
        unassigned.update(status: :received)

        result = Rules.unassigned

        expect(result).to eq [unassigned]
      end
    end
  end
end