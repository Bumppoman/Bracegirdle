require 'rails_helper'
require 'permissions_test'

describe CemeteriesController, type: :controller do
  before do
    @users = Hash.new
    @users[:investigator] = FactoryBot.create(:user)
    @users[:cemeterian] = FactoryBot.create(:cemeterian)
    @users[:accountant] = FactoryBot.create(:accountant)
    @users[:support] = FactoryBot.create(:support)
    @users[:another_investigator] = FactoryBot.create(:another_investigator)
    @users[:mean_supervisor] = FactoryBot.create(:mean_supervisor)
    @object = FactoryBot.create(:cemetery)
  end

  context 'All staff' do
    allowed = %i(investigator accountant support)
    disallowed = %i(cemeterian)

    permissions_test(allowed, disallowed, :index_by_county, :get, false, county: 4).call
    permissions_test(allowed, disallowed, :index_by_region, :get, false, region: 'binghamton').call
    permissions_test(allowed, disallowed, :index_with_overdue_inspections, :get).call
    permissions_test(allowed, disallowed, :show, :get, false, cemid: '04001').call
  end

  context 'Just supervisor' do
    allowed = %i(mean_supervisor)
    disallowed = %i(cemeterian investigator another_investigator accountant support)

    dummy_cemetery = FactoryBot.build(:cemetery, cemid: '04002').attributes
    permissions_test(allowed, disallowed, :create, :post, true, cemetery: dummy_cemetery, location: '42.0123123123,-74.123123123', status: :found).call
  end
end
