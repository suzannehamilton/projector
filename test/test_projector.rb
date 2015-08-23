require "minitest/autorun"
require "projector"

class TestProjector < Minitest::Test

  TEST_DB_FILE = "db/tasks_test.db"

  def setup
    File::delete(TEST_DB_FILE) if File::exist?(TEST_DB_FILE)
  end

  Minitest::after_run do
    File::delete(TEST_DB_FILE)
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

    assert_output("1 Shear the sheep\n") do
      Projector::start(["list"])
    end
  end

  def test_list_lists_multiple_added_tasks
    capture_io do
      Projector::start(["add", "Shear the sheep"])
      Projector::start(["add", "Feed the capybara"])
    end

    assert_output("1 Shear the sheep\n2 Feed the capybara\n") do
      Projector::start(["list"])
    end
  end

  def test_cannot_remove_task_from_empty_list
    assert_output("No task with number 1\n") do
      Projector::start(["complete", "1"])
    end
  end

  def test_cannot_remove_non_existent_task
    capture_io do
      Projector::start(["add", "Shear the sheep"])
    end

    assert_output("No task with number 5\n") do
      Projector::start(["complete", "5"])
    end
  end

  def test_can_remove_single_task
    capture_io do
      Projector::start(["add", "Shear the sheep"])
    end

    assert_output("Task 1 completed: \"Shear the sheep\"\n") do
      Projector::start(["complete", "1"])
    end

    assert_output("Nothing left to do!\n") do
      Projector::start(["list"])
    end
  end

  def test_can_remove_any_task
    capture_io do
      Projector::start(["add", "Shear the sheep"])
      Projector::start(["add", "Feed the capybara"])
      Projector::start(["add", "Shave the yak"])
    end

    assert_output("Task 2 completed: \"Feed the capybara\"\n") do
      Projector::start(["complete", "2"])
    end

    assert_output("1 Shear the sheep\n3 Shave the yak\n") do
      Projector::start(["list"])
    end
  end

  # TODO: Test non-natural number args for "complete" action - probably in unit tests rather than int. tests
  # TODO: Extract private method for "Projector::start to clean up tests"?
  # TODO: Split integration test into separate test classes for each command
end