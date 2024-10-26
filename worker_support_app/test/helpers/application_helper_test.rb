require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal "Worker Support App", full_title
    assert_equal "Help | Worker Support App", full_title("Help")
  end
end
