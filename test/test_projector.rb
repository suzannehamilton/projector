require "minitest/autorun"
require "projector"

class TestProjector < Minitest::Test

  # TODO SMH: Remove 'hello' task once there are real examples of calls which use arguments
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

  def test_adding_a_task_to_list_returns_task_name
    assert_output("Added 'Shear the sheep'\n") do
      Projector::start(["add", "Shear the sheep"])
    end
  end
end