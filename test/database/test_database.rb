require 'database/database'
require "minitest/autorun"

class TestDatabase < Minitest::Test

  TEST_DB_FILE = "db/tasks_test.db"

  def setup
    File::delete(TEST_DB_FILE) if File::exist?(TEST_DB_FILE)
    @task_factory = TaskFactory.new
    @database = Database.new(TEST_DB_FILE, @task_factory)
  end

  def after_tests
    File::delete(TEST_DB_FILE)
  end

  def test_task_list_is_empty_by_default
    assert_empty(@database.list)
  end

  def test_can_add_a_single_task
    task = @database.add(Task.new(nil, "Some task"))
    assert_equal(Task.new(1, "Some task"), task)
  end

  def test_can_add_a_single_task_with_units
    task = @database.add(Task.new(nil, "Some task", 0, "some units"))
    assert_equal(Task.new(1, "Some task", 0, "some units"), task)
  end

  def test_can_add_a_single_task_with_units_and_size
    task = @database.add(Task.new(nil, "Some task", 0, "some units", 55))
    assert_equal(Task.new(1, "Some task", 0, "some units", 55), task)
  end

  def test_rejects_adding_task_which_already_has_id
    new_task = Task.new(5, "some name")

    assert_raises ArgumentError do
      @database.add(new_task)
    end
  end

  def test_lists_single_task
    @database.add(Task.new(nil, "Some task"))
    assert_equal([Task.new(1, "Some task")], @database.list)
  end

  def test_lists_task_with_units
    @database.add(Task.new(nil, "Some task", 0, "some units"))
    assert_equal([Task.new(1, "Some task", 0, "some units")], @database.list)
  end

  def test_lists_task_with_units_and_size
    @database.add(Task.new(nil, "Some task", 0, "some units", 14))
    assert_equal([Task.new(1, "Some task", 0, "some units", 14)], @database.list)
  end

  def test_can_add_multiple_tasks
    @database.add(Task.new(nil, "some task"))
    @database.add(Task.new(nil, "other task"))
    @database.add(Task.new(nil, "yet another task"))
    assert_equal(
      [Task.new(1, "some task", 0), Task.new(2, "other task", 0), Task.new(3, "yet another task", 0)],
      @database.list)
  end

  def test_getting_a_task_from_empty_db_returns_nil
    assert_nil(@database.get(1))
  end

  def test_getting_a_non_existent_task_returns_nil
    @database.add(Task.new(nil, "some task"))
    @database.add(Task.new(nil, "other task"))
    assert_nil(@database.get(3))
  end

  def test_getting_a_task_by_id_returns_task
    @database.add(Task.new(nil, "some task"))
    assert_equal(Task.new(1, "some task"), @database.get(1))
  end

  def test_getting_a_task_by_id_returns_task_with_all_optional_properties
    @database.add(Task.new(nil, "some task", 0, "some units", 45))
    assert_equal(Task.new(1, "some task", 0, "some units", 45), @database.get(1))
  end

  def test_deleting_a_task_removes_it_from_the_db
    @database.add(Task.new(nil, "some task"))
    @database.delete(1)
  end

  def test_save_task_updates_task
    task = @database.add(Task.new(nil, "some task name"))
    updated_task = Task.new(task.id, "new name", 42, "new units", 77)
    @database.save(updated_task)

    assert_equal(updated_task, @database.get(task.id))
  end

  def test_save_task_can_make_optional_fields_nil
    task = @database.add(Task.new(nil, "some task name", 60, "original units", 80))
    updated_task = Task.new(task.id, "new name", 60)
    @database.save(updated_task)

    assert_equal(updated_task, @database.get(task.id))
  end

  def test_save_task_updates_value_in_list
    task = @database.add(Task.new(nil, "some task"))
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