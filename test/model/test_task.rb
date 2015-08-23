require "minitest/autorun"
require "model/task"

class TestTask < Minitest::Test

  def test_can_get_task_id
    task = Task.new(5, "a name")
    assert_equal(5, task.id)
  end

  def test_can_get_task_name
    task = Task.new(3, "some name")
    assert_equal("some name", task.name)
  end
end