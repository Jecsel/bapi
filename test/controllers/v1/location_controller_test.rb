require 'test_helper'

class V1::LocationControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get v1_location_create_url
    assert_response :success
  end

end
