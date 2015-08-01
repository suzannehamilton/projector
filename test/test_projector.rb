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

  # TODO: Test that an appropriate message is shown when deleting a non-existent task
  # TODO: Test that an existing task can be removed
  # TODO: Test that removing a task does not affect other tasks
end