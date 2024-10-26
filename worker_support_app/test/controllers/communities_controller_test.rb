require "test_helper"

class CommunitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get make_path
    assert_response :success
  end
end
