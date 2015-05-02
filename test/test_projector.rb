require "minitest/autorun"
require "projector"

class TestProjector < Minitest::Test
  def setup

  end

  def test_that_basic_test_can_run
    assert_output("Hello kitty\n") do
      Projector::start(["hello", "kitty"])
    end
  end
end