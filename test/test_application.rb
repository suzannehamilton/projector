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
    @database.expect(:list, ["Some task"])
    assert_equal("1 Some task", @application.list)
  end

  def test_lists_single_task
    @database.expect(:list, ["some task", "another task", "some other task"])
    assert_equal("1 some task\n2 another task\n3 some other task", @application.list)
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

  # TODO: Return the DB ID of the task, not just an in-memory index
end