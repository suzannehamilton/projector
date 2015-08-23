require "minitest/autorun"
require "model/task"

class TestTask < Minitest::Test

  def test_can_get_task_name
    task = Task.new("some name")
    assert_equal("some name", task.name)
  end
end