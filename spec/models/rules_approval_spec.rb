require 'rails_helper'

def create_rules_approval
  RulesApproval.new(
    cemetery_cemid: '04001',
    trustee_id: 1,
    request_by_email: true,
    sender_email: 'test@test.com'
  )
end

RSpec.describe RulesApproval, type: :model do
  subject { create_rules_approval }
  
  describe RulesApproval, 'Instance Methods' do
    describe RulesApproval, 'active?' do
      it 'returns true when the rules approval is active' do
        expect(subject.active?).to be true
      end
      
      it 'returns false when the rules approval is approved' do
        subject.status = :approved
        expect(subject.active?).to be false
      end
    end
    
    describe RulesApproval, 'assigned_to?' do
      it 'returns true when the rules approval is assigned to a user' do
        @investigator = FactoryBot.create(:user)
        subject.investigator = @investigator
        
        expect(subject.assigned_to?(@investigator)).to be true
      end
      
      it 'returns false when the rules approval is not assigned to a user' do
        @investigator = FactoryBot.create(:user)
        @another_investigator = FactoryBot.create(:another_investigator)
        subject.investigator = @investigator
        
        expect(subject.assigned_to?(@another_investigator)).to be false
      end
    end
    
    describe RulesApproval, 'concern_text' do
      it 'returns the correct text' do
        FactoryBot.create(:cemetery)
        subject.save
        
        expect(subject.concern_text).to eq [nil, 'rules', 'for Anthony Cemetery']
      end
    end
    
    describe RulesApproval, 'named_status' do
      it 'returns the correct named status' do
        expect(subject.named_status).to eq 'Received'
      end
    end
  end
  
  describe RulesApproval, 'Scopes' do
    before :each do
      FactoryBot.create(:cemetery)
      FactoryBot.create(:trustee)
      @active = create_rules_approval
      @active.status = :pending_review
      @active.save
    end
    
    describe RulesApproval, '.active' do
      it 'returns only active rules approvals' do
        approved = create_rules_approval
        approved.update(
          status: :approved
        )
        approved.save

        result = RulesApproval.active

        expect(result).to eq [@active]
      end
    end
    
    describe RulesApproval, '.active_for' do
      it "returns only the user's active rules approvals" do
        him = FactoryBot.create(:user)
        me = FactoryBot.create(:user)
        his_active = create_rules_approval
        his_active.investigator_id = 1
        his_active.save
        approved = create_rules_approval
        approved.update(
          status: :approved,
          investigator_id: 1
        )
        approved.save
        my_active = create_rules_approval
        my_active.investigator_id = 2
        my_active.status = :pending_review
        my_active.save
        my_approved = create_rules_approval
        my_approved.update(
          status: :approved,
          investigator_id: 2)
        my_approved.save

        result = RulesApproval.active_for(me)

        expect(result).to eq [my_active]
      end
      
      it 'returns unassigned rules approvals also for supervisors' do
        him = FactoryBot.create(:user)
        me = FactoryBot.create(:mean_supervisor)
        his_active = create_rules_approval
        his_active.investigator_id = 1
        his_active.status = :pending_review
        his_active.save
        approved = create_rules_approval
        approved.update(
          status: :approved,
          investigator_id: 1
        )
        approved.save
        my_active = create_rules_approval
        my_active.investigator_id = 2
        my_active.status = :pending_review
        my_active.save
        my_approved = create_rules_approval
        my_approved.update(
          status: :approved,
          investigator_id: 2)
        my_approved.save
        unassigned = create_rules_approval
        unassigned.save

        result = RulesApproval.active_for(me)

        expect(result).to eq [my_active, unassigned]
      end
    end
    
    describe RulesApproval, '.pending_review_for' do
      it "return's only the user's rules approvals that are pending review" do
        him = FactoryBot.create(:user)
        me = FactoryBot.create(:user)
        his_active = create_rules_approval
        his_active.investigator_id = 1
        his_active.save
        revision_requested = create_rules_approval
        revision_requested.update(
          status: :revision_requested,
          investigator_id: 1
        )
        revision_requested.save
        my_active = create_rules_approval
        my_active.investigator_id = 2
        my_active.status = :pending_review
        my_active.save
        my_revision_requested = create_rules_approval
        my_revision_requested.update(
          status: :revision_requested,
          investigator_id: 2)
        revision_requested.save

        result = RulesApproval.pending_review_for(me)

        expect(result).to eq [my_active]
      end
    end
  end
end
