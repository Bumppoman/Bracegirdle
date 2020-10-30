require 'rails_helper'
require 'permissions_test'

describe CemeteryInspectionsController, type: :controller do
  before do
    @users = Hash.new
    @users[:investigator] = FactoryBot.create(:user)
    @users[:cemeterian] = FactoryBot.create(:cemeterian)
    @users[:accountant] = FactoryBot.create(:accountant)
    @users[:support] = FactoryBot.create(:support)
    @users[:another_investigator] = FactoryBot.create(:another_investigator)
    @users[:mean_supervisor] = FactoryBot.create(:mean_supervisor)
    @cemetery = FactoryBot.create(:cemetery)
    @object = FactoryBot.create(:cemetery_inspection)
    @trustee = FactoryBot.create(:trustee)
    @completed = FactoryBot.create(:completed_inspection)
  end

  context 'All staff' do
    allowed = %i(investigator accountant support)
    disallowed = %i(cemeterian)
    actions = {
      show: :get,
      upload: :get,
      view_full_package: :get,
      view_report: :get
    }

    actions.each do |action, method|
      permissions_test(allowed, disallowed, action, method, false, cemid: '04001', identifier: "#{Date.current.year}-INSP-00002").call
    end

    permissions_test(allowed, disallowed, :create, :post, false, cemid: '04001', cemetery_inspection: { date_performed: '03/12/2020' }).call
  end

  context 'Just investigators' do
    allowed = %i(investigator another_investigator)
    disallowed = %i(cemeterian accountant support)

    permissions_test(allowed, disallowed, :incomplete, :get, false).call
    permissions_test(allowed, disallowed, :perform, :get, false, cemid: '04001').call
  end


  context 'Just the investigator who owns object' do
    allowed = %i(investigator)
    disallowed = %i(cemeterian another_investigator mean_supervisor accountant support)
    actions = {
      additional_information: :patch,
      cemetery_information: :patch,
      physical_characteristics: :patch,
      record_keeping: :patch
    }

    #actions.each do |action, method|
      #permissions_test(allowed, disallowed, action, method, false, cemetery_cemid: '04001', cemetery_inspection: { identifier: "#{Date.current.year}-INSP-00001" }).call
    #end

    permissions_test(allowed, disallowed, :finalize, :patch, false, format: :js, cemid: '04001', identifier: "#{Date.current.year}-INSP-00001").call
    permissions_test(allowed, disallowed, :revise, :patch, false, cemid: '04001', identifier: "#{Date.current.year}-INSP-00001", status: 302).call
  end
end
