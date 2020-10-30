require 'rails_helper'

RSpec.describe BoardApplications::Restorations::ContractorsController, type: :controller do
  context '#show' do
    before :each do
      @user = FactoryBot.create(:user)
      @contractor = FactoryBot.create(:contractor)
      request.env['HTTP_ACCEPT'] = 'application/json'
    end
    
    it 'returns the correct response' do
      get :show, params: { id: @contractor.id }, session: { user_id: @user.id }
      
      expect(response.body).to eq @contractor.to_json
    end
  end
end
