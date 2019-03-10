require 'rails_helper'

def create_rules
  Rules.new(
    cemetery: Cemetery.new(name: 'Anthony Cemetery', county: 4),
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

  context 'Actions' do
    describe Rules, '#after_commit' do
      it 'sets an identifier after saving' do
        subject.save

        expect(subject.identifier).to eq "#{subject.created_at.year}-#{'%04d' % subject.id}"
      end
    end
  end

  context 'Associations' do
    it { should belong_to :cemetery }
    it { should belong_to :investigator }
  end

  context 'Instance Methods' do
    describe Rules, '#active?' do
      it 'returns true if the rules are active' do
        expect(subject.active?).to be true
      end

      it 'returns false if the rules are not active' do
        subject.status = :approved

        expect(subject.active?).to be false
      end
    end

    describe Rules, '#approved?' do
      it 'returns true if the rules are approved' do
        subject.status = :approved

        expect(subject.approved?).to be true
      end

      it 'returns false if the rules are not approved' do
        expect(subject.approved?).to be false
      end
    end

    describe Rules, '#assigned_to?' do
      before :each do
        @me = User.new(password: 'Test')
        @me.save
        @him = User.new(password: 'Test')
        @him.save
      end

      it 'returns true if the rules are assigned to the user' do
        subject.investigator = @me

        expect(subject.assigned_to?(@me)).to be true
      end

      it 'returns false if the rules are assigned to nobody' do
        expect(subject.assigned_to?(@me)).to be false
      end

      it 'returns false if the rules are assigned to another user' do
        subject.investigator = @him

        expect(subject.assigned_to?(@me)).to be false
      end
    end

    describe Rules, '#concern_text' do
      it 'returns the correct text' do
        expect(subject.concern_text).to eq [nil, 'rules', 'for Anthony Cemetery']
      end
    end

    describe Rules, '#named_status' do
      it 'returns the correct status' do
        expect(subject.named_status).to eq 'Pending Review'
      end
    end

    describe Rules, '#previously_approved?' do
      it 'returns true if the rules were previously approved' do
        approved = Rules.new(
            cemetery: Cemetery.new(name: 'Anthony Cemetery', county: 4),
            submission_date: Date.current - 20,
            request_by_email: false,
            status: :approved
        )

        expect(approved.previously_approved?).to be true
      end

      it 'returns false if the rules were not previously approved' do
        expect(subject.previously_approved?).to be false
      end
    end

    describe Rules, '#revision_received?' do
      before :each do
        subject.rules_documents.attach(io: File.open(Rails.root.join('lib', 'document_templates', 'rules-approval.docx')), filename: 'Rules.docx', content_type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')
        subject.save
      end

      it 'returns true if a revision was not requested' do
        expect(subject.revision_received?).to be true
      end

      it 'returns false if a revision was requested but not received' do
        subject.revision_request_date = Date.current + 2

        expect(subject.revision_received?).to be false
      end

      it 'returns true if a revision was requested and received' do
        subject.revision_request_date = Date.current - 2
        subject.rules_documents.attach(io: File.open(Rails.root.join('lib', 'document_templates', 'rules-approval.docx')), filename: 'Rules.docx', content_type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')
        subject.save

        expect(subject.revision_received?).to be true
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

  context 'Scopes' do
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

  context 'Validations' do
    describe Rules do
      context 'New rules' do
        it 'is valid with valid attributes' do
          expect(subject.valid?).to be true
        end

        it 'is not valid without knowing the request type' do
          subject.request_by_email = nil

          expect(subject.valid?).to be false
        end

        it 'is not valid without the sender' do
          subject.sender = nil

          expect(subject.valid?).to be false
        end

        it 'is not valid without email if request is by email' do
          subject.update(
            request_by_email: true,
            sender_street_address: nil,
            sender_city: nil,
            sender_state: nil,
            sender_zip: nil
          )

          expect(subject.valid?).to be false
        end

        it 'is not valid without street address if request is by mail' do
          subject.sender_street_address = nil

          expect(subject.valid?).to be false
        end

        it 'is not valid without city if request is by mail' do
          subject.sender_city = nil

          expect(subject.valid?).to be false
        end

        it 'is not valid without state if request is by mail' do
          subject.sender_state = nil

          expect(subject.valid?).to be false
        end

        it 'is not valid without zip code if request is by mail' do
          subject.sender_zip = nil

          expect(subject.valid?).to be false
        end
      end

      context 'Previously approved' do
        before :each do
          subject.update(
            status: :approved,
            approval_date: '2012-04-04'
          )
        end

        it 'is valid without knowing the request type' do
          subject.request_by_email = nil

          subject.validate
          expect(subject.valid?).to be true
        end

        it 'is valid without the sender' do
          subject.sender = nil

          expect(subject.valid?).to be true
        end

        it 'is not valid without the approval date' do
          subject.approval_date = nil

          expect(subject.valid?).to be false
        end
      end
    end
  end
end