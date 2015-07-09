require "minitest/autorun"
require "projector"

class TestProjector < Minitest::Test

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

  def test_adding_a_task_adds_it_to_list_of_tasks
    skip("Unskip once unit tests for adding a task")
    # TODO: Work out how to suppress the output of this in the console
    Projector::start(["add", "Shear the sheep"])

    assert_output("Shear the sheep\n") do
      Projector::start(["list"])
    end
  end
end