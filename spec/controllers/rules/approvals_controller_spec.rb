require 'rails_helper'
require 'permissions_test'

describe Rules::ApprovalsController, type: :controller do
  before do
    @users = Hash.new
    @users[:investigator] = FactoryBot.create(:user)
    @users[:cemeterian] = FactoryBot.create(:cemeterian)
    @users[:accountant] = FactoryBot.create(:accountant)
    @users[:support] = FactoryBot.create(:support)
    @users[:another_investigator] = FactoryBot.create(:another_investigator)
    @users[:mean_supervisor] = FactoryBot.create(:mean_supervisor)
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
    @object = FactoryBot.create(:rules_approval, investigator_id: 1, status: :pending_review)
    @unassigned = FactoryBot.create(:rules_approval)
  end

  context 'All staff' do
    allowed = %i(investigator accountant support)
    disallowed = %i(cemeterian)

    dummy_rules = FactoryBot.build(:rules).attributes
    dummy_rules[:trustee] = 1
    permissions_test(allowed, disallowed, :create, :post, true, rules_approval: dummy_rules).call
    permissions_test(allowed, disallowed, :download_approval_letter, :get, true, filename: 'Test.pdf').call
    permissions_test(allowed, disallowed, :new, :get, false).call
  end
  
  context 'Just the investigator who owns object or supervisor' do
    allowed = %i(investigator mean_supervisor)
    disallowed = %i(cemeterian another_investigator accountant support)
    
    permissions_test(allowed, disallowed, :show, :get, true).call
  end

  context 'Just the investigator who owns object' do
    allowed = %i(investigator)
    disallowed = %i(cemeterian another_investigator mean_supervisor accountant support)

    #permissions_test(allowed, disallowed, :approve, :patch, true, format: :js, status: 302).call
  end

  context 'Just supervisor' do
    allowed = %i(mean_supervisor)
    disallowed = %i(cemeterian investigator another_investigator accountant support)

    permissions_test(allowed, disallowed, :approve, :patch, true, format: :js, object_id: 2, status: 302).call
    permissions_test(allowed, disallowed, :assign, :patch, true, rules_approval: { investigator: 2 }, status: :found).call
  end
end
