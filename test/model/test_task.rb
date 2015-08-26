require "minitest/autorun"
require "model/task"

class TestTask < Minitest::Test

  def test_can_get_task_id
    task = Task.new(5, "a name", 20)
    assert_equal(5, task.id)
  end

  def test_can_get_task_name
    task = Task.new(3, "some name", 10)
    assert_equal("some name", task.name)
  end

  def test_can_get_percentage_done
    task = Task.new(4, "some name", 57)
    assert_equal(57, task.percent_done)
  end
end