require 'rails_helper'

describe 'Contractors', type: :request do
  it 'Returns the correct contractors as JSON' do
    @contractor = FactoryBot.create(:contractor)
    headers = { "ACCEPT" => "application/json" }
    login
    
    get board_applications_restorations_contractors_path, headers: headers
    
    expect(response.body).to eq [{ label: @contractor.name, value: @contractor.id }].to_json
  end
end