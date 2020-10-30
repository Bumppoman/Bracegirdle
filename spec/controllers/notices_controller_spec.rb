require 'rails_helper'
require 'permissions_test'

describe NoticesController, type: :controller do
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
    @object = FactoryBot.create(:notice)
  end

  context 'All staff' do
    allowed = %i(investigator accountant support)
    disallowed = %i(cemeterian)
    actions = {
      index: :get,
      new: :get
    }

    actions.each do |action, method|
      permissions_test(allowed, disallowed, action, method).call
    end

    dummy_notice = FactoryBot.build(:notice).attributes
    dummy_notice[:trustee] = 1;
    permissions_test(allowed, disallowed, :create, :post, true, notice: dummy_notice).call
    permissions_test(allowed, disallowed, :download, :get, true, filename: 'Test.pdf').call
    permissions_test(allowed, disallowed, :show, :get, true).call
  end

  context 'Just the investigator who owns object' do
    allowed = %i(investigator)
    disallowed = %i(cemeterian another_investigator mean_supervisor accountant support)

    permissions_test(allowed, disallowed, :follow_up, :patch, true, format: :js, notice: { follow_up_inspection_date: '3/12/2020' }).call
    permissions_test(allowed, disallowed, :resolve, :patch, true, format: :js).call
    permissions_test(allowed, disallowed, :receive_response, :patch, true, format: :js).call
  end
end
