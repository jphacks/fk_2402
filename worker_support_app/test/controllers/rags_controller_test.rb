require "test_helper"

class RagsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get rags_create_url
    assert_response :success
  end
end
