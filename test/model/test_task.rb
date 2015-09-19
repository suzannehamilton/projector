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

  def test_can_get_progress
    task = Task.new(4, "some name", 57)
    assert_equal(57, task.progress)
  end

  def test_can_get_units
    task = Task.new(7, "some name", 33, "some units")
    assert_equal("some units", task.units)
  end

  def test_can_get_size
    task = Task.new(1, "some name", 80, "some units", 4)
    assert_equal(4, task.size)
  end

  def test_task_with_zero_percent_progress_is_not_complete
    task = Task.new(1, "some name", 0)
    refute task.complete?
  end

  def test_task_with_zero_progress_is_not_complete
    task = Task.new(1, "some name", 0, "some units", 20)
    refute task.complete?
  end

  def test_task_with_less_than_100_percent_progress_is_not_complete
    task = Task.new(1, "some name", 99)
    refute task.complete?
  end

  def test_task_with_less_than_full_progress_is_not_complete
    task = Task.new(1, "some name", 19, "some units", 20)
    refute task.complete?
  end

  def test_task_with_100_percent_progress_is_complete
    task = Task.new(1, "some name", 100)
    assert task.complete?
  end

  def test_task_with_full_progress_is_complete
    task = Task.new(1, "some name", 67, "some units", 67)
    assert task.complete?
  end
end