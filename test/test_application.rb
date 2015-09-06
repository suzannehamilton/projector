require "minitest/autorun"
require "thor"
require "application"

class TestApplication < Minitest::Test

  def setup
    @database = MiniTest::Mock.new
    @renderer = MiniTest::Mock.new
    @application = Application.new(@database, @renderer)
  end

  def test_listing_empty_task_list_identifies_that_no_tasks_are_available
    @database.expect(:list, [])
    assert_equal([], @application.list)
  end

  def test_lists_single_task
    task = Task.new(5, "Some task", 12)

    @database.expect(:list, [task])
    @renderer.expect(:render, "Rendered task", [task])

    assert_equal(["Rendered task"], @application.list)
  end

  def test_lists_multiple_tasks
    task1 = Task.new(3, "some task", 0)
    task2 = Task.new(7, "another task", 98)
    task3 = Task.new(8, "some other task", 34)

    @database.expect(:list, [task1, task2, task3])

    @renderer.expect(:render, "Rendered task 1", [task1])
    @renderer.expect(:render, "Rendered task 2", [task2])
    @renderer.expect(:render, "Rendered task 3", [task3])

    assert_equal(["Rendered task 1", "Rendered task 2", "Rendered task 3"], @application.list)
  end

  def test_adding_a_task_to_list_adds_task_and_returns_task_id_and_name
    @database.expect(:add, Task.new(7, "Saved task name", 0), ["Some task"])
    assert_equal("Added task 7: 'Saved task name'", @application.add("Some task"))
    @database.verify
  end

  def test_cannot_remove_non_existent_task
    @database.expect(:get, nil, [4])

    e = assert_raises Thor::MalformattedArgumentError do
      @application.complete(4)
    end

    assert_equal("No task with number 4", e.message)

    @database.verify
  end

  def test_can_complete_a_task
    @database.expect(:get, Task.new(6, "Shear the sheep", 55), [6])
    @database.expect(:delete, nil, [6])

    assert_equal("Task 6 completed: \"Shear the sheep\"", @application.complete(6))

    @database.verify
  end

  def test_update_percentage
    @database.expect(:get, Task.new(4, "Some task name", 20), [4])
    @database.expect(:update, nil, [4, 33])
    assert_equal("Updated task 4, 'Some task name' to 33%", @application.update(4, 33))

    @database.verify
  end

  def test_update_zero_percentage
    @database.expect(:get, Task.new(4, "Some task name", 20), [4])
    @database.expect(:update, nil, [4, 0])
    assert_equal("Updated task 4, 'Some task name' to 0%", @application.update(4, 0))

    @database.verify
  end

  def test_percent_done_cannot_be_negative
    e = assert_raises Thor::MalformattedArgumentError do
      @application.update(4, -12)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 100, but got '-12'", e.message)
  end

  def test_percent_done_cannot_be_more_than_100_percent
    e = assert_raises Thor::MalformattedArgumentError do
      @application.update(7, 101)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 100, but got '101'", e.message)
  end

  def test_cannot_update_non_existent_task
    @database.expect(:get, nil, [3])

    e = assert_raises Thor::MalformattedArgumentError do
      @application.update(3, 20)
    end

    assert_equal("No task with number 3", e.message)
    @database.verify
  end

  def test_updating_progress_to_100_percent_marks_task_as_complete
    @database.expect(:get, Task.new(6, "Shear the sheep", 55), [6])
    @database.expect(:delete, nil, [6])

    assert_equal("Task 6 completed: \"Shear the sheep\"", @application.update(6, 100))

    @database.verify
  end
end