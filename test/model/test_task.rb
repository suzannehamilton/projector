require "minitest/autorun"
require "model/task"

class TestTask < Minitest::Test

  def test_can_get_task_id
    task = Task.new(5, "a name", 20)
    assert_equal(5, task.id)
  end

  def test_nil_task_id_is_valid
    task = Task.new(nil, "a name", 50)
    assert_nil(task.id)
  end

  def test_zero_task_id_is_invalid
    e = assert_raises ArgumentError do
      Task.new(0, "some name", 25)
    end

    assert(e.message.include?("0"))
  end

  def test_negative_task_id_is_invalid
    e = assert_raises ArgumentError do
      Task.new(-1, "some name", 30)
    end

    assert(e.message.include?("-1"))
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