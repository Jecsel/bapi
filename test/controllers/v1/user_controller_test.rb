require 'test_helper'

class V1::UserControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get v1_user_index_url
    assert_response :success
  end

end
