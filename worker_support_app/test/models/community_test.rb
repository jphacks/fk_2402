require "test_helper"

class CommunityTest < ActiveSupport::TestCase
  def setup
    @community = Community.new(name: "Company A", abstruct: "This is a community for employee of Company A.")
  end

  test "should be valid" do
    assert @community.valid?
  end

  test "name should be present" do
    @community.name = "     "
    assert_not @community.valid?
  end
end
