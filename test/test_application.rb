require "minitest/autorun"
require "application"

class TestApplication < Minitest::Test

  def setup
    @database = MiniTest::Mock.new
    @application = Application.new(@database)
  end

  def test_listing_empty_task_list_identifies_that_no_tasks_are_available
    @database.expect(:list, [])
    assert_equal("Nothing left to do!", @application.list)
  end

  def test_lists_single_task
    @database.expect(:list, [Task.new(5, "Some task")])
    assert_equal("5 Some task", @application.list)
  end

  def test_lists_multiple_tasks
    @database.expect(:list, [Task.new(3, "some task"), Task.new(7, "another task"), Task.new(8, "some other task")])
    assert_equal("3 some task\n7 another task\n8 some other task", @application.list)
  end

  # TODO: Format task numbers and names nicely, so that starts of tasks always line up

  def test_adding_a_task_to_list_adds_task_and_returns_task_name
    @database.expect(:add, nil, ["Some task"])
    assert_equal("Added 'Some task'", @application.add("Some task"))
    @database.verify
  end

  def test_cannot_remove_non_existent_task
    @database.expect(:get, nil, [4])
    assert_equal("No task with number 4", @application.complete("4"))
    @database.verify
  end

  def test_can_remove_a_task
    @database.expect(:get, "Shear the sheep", [6])
    @database.expect(:delete, nil, [6])

    assert_equal("Task 6 completed: \"Shear the sheep\"", @application.complete("6"))

    @database.verify
  end

  def test_completion_rejects_invalid_task_id
    assert_equal("Invalid task ID 'not_an_integer'", @application.complete("not_an_integer"))
  end
end