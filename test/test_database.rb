require 'database'
require "minitest/autorun"

class TestDatabase < Minitest::Test

  TEST_DB_FILE = "db/tasks.db"

  def setup
    @database = Database.new(TEST_DB_FILE)
  end

  def teardown
    File::delete(TEST_DB_FILE)
  end

  def test_task_list_is_empty_by_default
    assert_empty(@database.list)
  end

  def test_can_add_a_single_task
    @database.add("Some task")
    assert_equal(["Some task"], @database.list)
  end

  # TODO: Test adding multiple tasks
end