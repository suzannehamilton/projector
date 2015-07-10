require 'database'
require "minitest/autorun"

class TestDatabase < Minitest::Test

  def setup
    @database = Database.new
  end

  def teardown
    # Pass DB location into constructor
    File::delete("db/tasks.db")
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