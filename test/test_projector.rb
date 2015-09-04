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
      Projector.new.invoke(:list)
    end
  end

  def test_adding_a_task_to_list_returns_task_name
    assert_output("Added 'Shear the sheep'\n") do
      Projector.new.invoke(:add, ["Shear the sheep"])
    end
  end

  def test_adding_a_task_adds_it_to_list_of_tasks
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"])
    end

    assert_output("1  Shear the sheep  0%\n") do
      Projector.new.invoke(:list)
    end
  end

  def test_list_lists_multiple_added_tasks
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"])
      Projector.new.invoke(:add, ["Feed the capybara"])
    end

    assert_output("1  Shear the sheep    0%\n2  Feed the capybara  0%\n") do
      Projector.new.invoke(:list)
    end
  end

  def test_cannot_complete_task_from_empty_list
    assert_output("No task with number 1\n") do
      Projector.new.invoke(:complete, ["1"])
    end
  end

  def test_cannot_complete_non_existent_task
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"])
    end

    assert_output("No task with number 5\n") do
      Projector.new.invoke(:complete, ["5"])
    end
  end

  def test_can_complete_single_task
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"])
    end

    assert_output("Task 1 completed: \"Shear the sheep\"\n") do
      Projector.new.invoke(:complete, ["1"])
    end

    assert_output("Nothing left to do!\n") do
      Projector.new.invoke(:list)
    end
  end

  def test_can_complete_any_task
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"])
      Projector.new.invoke(:add, ["Feed the capybara"])
      Projector.new.invoke(:add, ["Shave the yak"])
    end

    assert_output("Task 2 completed: \"Feed the capybara\"\n") do
      Projector.new.invoke(:complete, ["2"])
    end

    assert_output("1  Shear the sheep  0%\n3  Shave the yak    0%\n") do
      Projector.new.invoke(:list)
    end
  end

  def test_completion_rejects_invalid_task_id
    assert_raises Thor::MalformattedArgumentError do
      Projector.new.invoke(:complete, ["invalid_task_id"])
    end
  end

  def test_can_update_done_percentage
    capture_io do
      Projector.new.invoke(:add, ["Comb the rabbit"])
    end

    assert_output("1 Comb the rabbit 60%\n") do
      Projector.new.invoke(:update, ["1", "60"])
    end

    assert_output("1  Comb the rabbit  60%\n") do
      Projector.new.invoke(:list)
    end
  end

  def test_updating_rejects_invalid_task_id
    capture_io do
      Projector.new.invoke(:add, ["Comb the rabbit"])
    end

    assert_raises Thor::MalformattedArgumentError do
      Projector.new.invoke(:update, ["invalid_id", "60"])
    end
  end

  # TODO: Split integration test into separate test classes for each command
end