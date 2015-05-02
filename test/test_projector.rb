require "minitest/autorun"
require "projector"

class TestProjector < Minitest::Test
  def setup

  end

  def test_that_basic_test_can_run

    Projector::start(["help", "hello"])
    assert_equal "Hello kitty", "Hello kitty"
  end
end