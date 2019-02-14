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
    describe Rules, '#accepted_by?' do
      it 'returns true if the rules were accepted by the user' do
        user = User.new
        subject.accepted_by = user

        expect(subject.accepted_by?(user)).to be true
      end

      it 'returns false if the rules were not accepted' do
        expect(subject.accepted_by?(User.new)).to be false
      end

      it 'returns false if the rules were accepted by another user' do
        subject.accepted_by = User.new

        expect(subject.accepted_by?(User.new)).to be false
      end
    end

    describe Rules, '#approved?' do
      it 'returns approved if the rules are approved' do
        subject.status = :approved

        expect(subject.approved?).to be true
      end

      it 'returns false if the rules are not approved' do
        expect(subject.approved?).to be false
      end
    end

    describe Rules, '#assigned_to?' do
      it 'returns true if the rules are assigned to the user' do
        user = User.new(region: 5)

        expect(subject.assigned_to?(user)).to be true
      end

      it 'returns false if the rules are not assigned to the user' do
        user = User.new(region: 4)

        expect(subject.assigned_to?(user)).to be false
      end

      it 'returns false if the rules would be assigned to the user but were already accepted' do
        user = User.new(region: 5)
        accepter = User.new(region: 4)
        subject.accepted_by = accepter

        expect(subject.assigned_to?(user)).to be false
      end
    end

    describe Rules, '#named_status' do
      it 'returns the correct status' do
        expect(subject.named_status).to eq 'Received'
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

    describe Rules, '#unaccepted?' do
      it 'returns true if the rules were not accepted' do
        expect(subject.unaccepted?).to be true
      end

      it 'returns false if the rules were accepted' do
        subject.status = :pending_review

        expect(subject.unaccepted?).to be false
      end
    end
  end

  describe 'Scopes' do
    before :each do
      @me = User.new(password: 'test', region: 5)
      @me.save
      @active = create_rules
      @active.save
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
        @him = User.new(password: 'test', region: 4)
        @him.save
      end

      it 'returns only active rules' do
        approved = create_rules
        approved.update(cemetery: Cemetery.new(county: 4), status: Rules::STATUSES[:approved])
        his_active = create_rules
        his_active.update(cemetery: Cemetery.new(county: 6))

        result = Rules.active_for(@me)

        expect(result).to eq [@active]
      end

      it 'also returns rules user has accepted' do
        accepted = create_rules
        accepted.update(cemetery: Cemetery.new(county: 6), accepted_by: @me, status: Rules::STATUSES[:accepted])
        not_accepted = create_rules
        not_accepted.update(cemetery: Cemetery.new(county: 6))

        result = Rules.active_for(@me)

        expect(result).to eq [@active, accepted]
      end

      it "doesn't return rules that would be assigned to user but were accepted by someone else" do
        accepted_by_him = create_rules
        accepted_by_him.update(accepted_by: @him, status: Rules::STATUSES[:accepted])

        result = Rules.active_for(@me)

        expect(result).to eq [@active]
      end

      it 'also returns rules that are awaiting revisions' do
        awaiting_revisions = create_rules
        awaiting_revisions.update(status: Rules::STATUSES[:revision_requested])

        result = Rules.active_for(@me)

        expect(result).to eq [@active, awaiting_revisions]
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
      before :each do
        @him = User.new(password: 'test', region: 4)
        @him.save
      end

      it 'returns only rules pending review' do
        approved = create_rules
        approved.update(cemetery: Cemetery.new(county: 4), status: Rules::STATUSES[:approved])
        his_active = create_rules
        his_active.update(cemetery: Cemetery.new(county: 6))

        result = Rules.pending_review_for(@me)

        expect(result).to eq [@active]
      end

      it 'also returns rules user has accepted' do
        accepted = create_rules
        accepted.update(cemetery: Cemetery.new(county: 6), accepted_by: @me, status: Rules::STATUSES[:accepted])
        not_accepted = create_rules
        not_accepted.update(cemetery: Cemetery.new(county: 6))

        result = Rules.pending_review_for(@me)

        expect(result).to eq [@active, accepted]
      end

      it "doesn't return rules that would be assigned to user but were accepted by someone else" do
        accepted_by_him = create_rules
        accepted_by_him.update(accepted_by: @him, status: Rules::STATUSES[:accepted])

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

    describe Rules, '.pending_review_for_region' do
      it 'only returns rules for the requested region' do
        other_region = create_rules
        other_region.update(cemetery: Cemetery.new(county: 6))

        result = Rules.pending_review_for_region(5)

        expect(result).to eq [@active]
      end

      it 'only returns rules that are pending review' do
        approved = create_rules
        approved.update(status: Rules::STATUSES[:approved])

        result = Rules.pending_review_for_region(5)

        expect(result).to eq [@active]
      end

      it "doesn't return rules that were accepted" do
        @him = User.new(region: 4)
        @him.save
        his_rules = create_rules
        his_rules.update(accepted_by: @him, status: Rules::STATUSES[:accepted])

        result = Rules.pending_review_for_region(5)

        expect(result).to eq [@active]
      end
    end
  end
end