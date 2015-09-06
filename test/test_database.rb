require 'database'
require "minitest/autorun"

class TestDatabase < Minitest::Test

  TEST_DB_FILE = "db/tasks_test.db"

  def setup
    File::delete(TEST_DB_FILE) if File::exist?(TEST_DB_FILE)
    @database = Database.new(TEST_DB_FILE)
  end

  def after_tests
    File::delete(TEST_DB_FILE)
  end

  def test_task_list_is_empty_by_default
    assert_empty(@database.list)
  end

  def test_can_add_a_single_task
    task = @database.add("Some task")
    assert_equal(Task.new(1, "Some task", 0), task)
    # TODO: Split into separate test
    assert_equal([Task.new(1, "Some task", 0)], @database.list)
  end

  def test_can_add_multiple_tasks
    @database.add("some task")
    @database.add("other task")
    @database.add("yet another task")
    assert_equal(
      [Task.new(1, "some task", 0), Task.new(2, "other task", 0), Task.new(3, "yet another task", 0)],
      @database.list)
  end

  def test_getting_a_task_from_empty_db_returns_nil
    assert_nil(@database.get(1))
  end

  def test_getting_a_non_existent_task_returns_nil
    @database.add("some task")
    @database.add("other task")
    assert_nil(@database.get(3))
  end

  def test_getting_a_task_by_id_returns_task
    @database.add("some task")
    assert_equal(Task.new(1, "some task", 0), @database.get(1))
  end

  def test_deleting_a_task_removes_it_from_the_db
    @database.add("some task")
    @database.delete(1)
  end

  def test_update_task_done_percentage
    @database.add("some task")
    @database.update(1, 46)
    assert_equal(46, @database.get(1).percent_done)
  end

  def test_update_task_done_percentage_updates_value_in_list
    @database.add("some task")
    @database.update(1, 75)
    assert_equal([Task.new(1, "some task", 75)], @database.list)
  end
end