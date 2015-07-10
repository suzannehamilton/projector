require "minitest/autorun"
require "projector"

class TestProjector < Minitest::Test

  def setup
    # TODO: Find a better way to get hold of this file name
    File::delete("db/tasks.db") if File::exist?("db/tasks.db")
  end

  def teardown
    # TODO: Find a better way to get hold of this file name
    # Use a class-level teardown for this, since it's already being deleted at the start of every test
    File::delete("db/tasks.db")
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

  def test_adding_a_task_adds_it_to_list_of_tasks
    capture_io do
      Projector::start(["add", "Shear the sheep"])
    end

    assert_output("Shear the sheep\n") do
      Projector::start(["list"])
    end
  end
end