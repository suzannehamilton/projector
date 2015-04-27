require "minitest/autorun"
require "projector"

class TestProjector < Minitest::Test
  def setup
    @projector = Projector.new
  end

  def test_that_basic_test_can_run
    assert_equal "foo", "foo"
  end
end