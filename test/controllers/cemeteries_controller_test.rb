require 'test_helper'

class CemeteriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cemeteries_index_url
    assert_response :success
  end

end
