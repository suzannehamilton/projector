require "minitest/autorun"
require "projector"

class TestProjector < Minitest::Test
  def test_basic_command_line_call_picks_up_arguments
    assert_output("Hello kitty\n") do
      Projector::start(["hello", "kitty"])
    end
  end

  def test_listing_empty_task_list_identifies_that_no_tasks_are_available
      assert_output("Nothing left to do!\n") do
        Projector::start(["list"])
      end
  end
end