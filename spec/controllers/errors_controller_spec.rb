require 'rails_helper'

RSpec.describe ErrorsController, type: :controller do
  describe 'GET forbidden' do
    it 'has the status 403' do
      get :forbidden

      expect(response).to have_http_status(403)
    end
  end

  describe 'GET internal_server_error' do
    it 'has the status 500' do
      get :internal_server_error

      expect(response).to have_http_status(500)
    end
  end
end
