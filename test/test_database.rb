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
  end

  def test_can_add_a_single_task_with_units
    task = @database.add("Some task", "some units")
    assert_equal(Task.new(1, "Some task", 0, "some units"), task)
  end

  def test_can_add_a_single_task_with_units_and_size
    task = @database.add("Some task", "some units", 55)
    assert_equal(Task.new(1, "Some task", 0, "some units", 55), task)
  end

  def test_lists_single_task
    @database.add("Some task")
    assert_equal([Task.new(1, "Some task", 0)], @database.list)
  end

  def test_lists_task_with_units
    @database.add("Some task", "some units")
    assert_equal([Task.new(1, "Some task", 0, "some units")], @database.list)
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

  # TODO: Test getting a task with all properties

  def test_deleting_a_task_removes_it_from_the_db
    @database.add("some task")
    @database.delete(1)
  end

  def test_save_task_updates_task
    task = @database.add("some task name")
    updated_task = Task.new(task.id, "new name", 42, "new units")
    @database.save(updated_task)

    assert_equal(updated_task, @database.get(task.id))
  end

  def test_save_task_updates_value_in_list
    task = @database.add("some task")
    updated_task = Task.new(task.id, "new name", 75, "new units")
    @database.save(updated_task)

    assert_equal([updated_task], @database.list)
  end

  def test_save_task_rejects_task_with_no_id
    new_task = Task.new(nil, "new name", 42, "new units")

    assert_raises ArgumentError do
      @database.save(new_task)
    end
  end
end