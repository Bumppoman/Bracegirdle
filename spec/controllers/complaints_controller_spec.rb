require 'rails_helper'
require 'permissions_test'

describe ComplaintsController, type: :controller do
  before do
    @users = Hash.new
    @users[:investigator] = FactoryBot.create(:user)
    @users[:cemeterian] = FactoryBot.create(:cemeterian)
    @users[:accountant] = FactoryBot.create(:accountant)
    @users[:support] = FactoryBot.create(:support)
    @users[:another_investigator] = FactoryBot.create(:another_investigator)
    @users[:mean_supervisor] = FactoryBot.create(:mean_supervisor)
    @cemetery = FactoryBot.create(:cemetery)
    @object = FactoryBot.create(:brand_new_complaint)
  end

  context 'All staff' do
    allowed = %i(investigator accountant support)
    disallowed = %i(cemeterian)
    actions = {
      all: :get,
      index: :get,
      new: :post,
      pending_closure: :get,
      unassigned: :get
    }

    actions.each do |action, method|
      permissions_test(allowed, disallowed, action, method).call
    end

    dummy_complaint = FactoryBot.build(:brand_new_complaint).attributes
    dummy_complaint['complaint_type'] = [1]
    dummy_complaint['receiver'] = 1
    permissions_test(allowed, disallowed, :create, :post, true, complaint: dummy_complaint).call
    permissions_test(allowed, disallowed, :show, :get, true).call
  end

  context 'Just the investigator who owns object or supervisor' do
    allowed = %i(investigator mean_supervisor)
    disallowed = %i(cemeterian another_investigator accountant support)
    actions = {
      close: :patch
    }

    actions.each do |action, method|
      permissions_test(allowed, disallowed, action, method, true).call
    end

    permissions_test(allowed, disallowed, :begin_investigation, :patch, true, format: :js).call
    permissions_test(allowed, disallowed, :change_investigator, :patch, true, format: :js, complaint: { investigator: 1 }).call
  end

  context 'Just the investigator who owns object' do
    allowed = %i(investigator)
    disallowed = %i(cemeterian another_investigator mean_supervisor accountant support)

    permissions_test(allowed, disallowed, :complete_investigation, :patch, true, format: :js).call
  end

  context 'Just supervisor' do
    allowed = %i(mean_supervisor)
    disallowed = %i(cemeterian investigator another_investigator accountant support)

    permissions_test(allowed, disallowed, :assign, :patch, true, format: :js, complaint: { investigator: 1 }).call
    permissions_test(allowed, disallowed, :reopen_investigation, :patch, true, status: :found, format: :js, complaint: { investigator: 1 }).call
    permissions_test(allowed, disallowed, :request_update, :patch, true, format: :js, complaint: { investigator: 1 }).call
  end
end
