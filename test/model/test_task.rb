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

  def test_name_must_be_present
    e = assert_raises ArgumentError do
      Task.new(5, nil)
    end

    assert(e.message.include?("name"))
  end

  def test_can_get_progress
    task = Task.new(4, "some name", 57)
    assert_equal(57, task.progress)
  end

  def test_zero_progress_is_valid
    task = Task.new(4, "some name", 0)
    assert_equal(0, task.progress)
  end

  def test_default_progress_is_zero
    task = Task.new(4, "some name")
    assert_equal(0, task.progress)
  end

  def test_negative_progress_is_invalid
    e = assert_raises Thor::MalformattedArgumentError do
      Task.new(1, "some name", -2)
    end

    assert(e.message.include?("-2"))
  end

  def test_negative_progress_of_task_with_custom_size_is_invalid
    e = assert_raises Thor::MalformattedArgumentError do
      Task.new(1, "some name", -2, "some units", 10)
    end

    assert(e.message.include?("-2"))
  end

  def test_progress_greater_than_100_percent_is_invalid
    e = assert_raises Thor::MalformattedArgumentError do
      Task.new(1, "some name", 101)
    end

    assert(e.message.include?("101"))
  end

  def test_progress_greater_than_100_is_valid_if_task_is_larger_than_100_units
    task = Task.new(4, "some name", 120, "some units", 130)
    assert_equal(120, task.progress)
  end

  def test_progress_greater_than_custom_task_size_is_invalid
    e = assert_raises Thor::MalformattedArgumentError do
      Task.new(1, "some name", 41, "some units", 40)
    end

    assert(e.message.include?("41"))
    assert(e.message.include?("40"))
  end

  def test_can_get_units
    task = Task.new(7, "some name", 33, "some units")
    assert_equal("some units", task.units)
  end

  def test_can_get_size
    task = Task.new(1, "some name", 2, "some units", 4)
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

  def test_updating_progress_preserves_other_fields
    task = Task.new(4, "some name", 30, "some units", 90)
    updated_task = task.update_progress(82)

    assert_equal(4, updated_task.id)
    assert_equal("some name", updated_task.name)
    assert_equal("some units", updated_task.units)
    assert_equal(90, updated_task.size)
  end

  def test_can_update_progress_of_task_with_default_units
    task = Task.new(5, "some name", 54)
    updated_task = task.update_progress(80)

    assert_equal(80, updated_task.progress)
  end

  def test_can_update_percentage_to_zero
    task = Task.new(4, "Some task name", 20)
    updated_task = task.update_progress(0)

    assert_equal(0, updated_task.progress)
  end

  def test_progress_cannot_be_negative
    task = Task.new(4, "some name", 0)

    e = assert_raises Thor::MalformattedArgumentError do
      task.update_progress(-12)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 100, but got '-12'", e.message)
  end

  def test_percent_done_cannot_be_more_than_100_percent
    task = Task.new(4, "some name", 0)

    e = assert_raises Thor::MalformattedArgumentError do
      task.update_progress(101)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 100, but got '101'", e.message)
  end

  def test_progress_of_custom_size_task_cannot_be_negative
    task = Task.new(4, "some name", 0, "some units", 50)

    e = assert_raises Thor::MalformattedArgumentError do
      task.update_progress(-1)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 50, but got '-1'", e.message)
  end

  def test_progress_of_custom_size_task_cannot_be_more_than_task_size
    task = Task.new(4, "some name", 0, "some units", 50)

    e = assert_raises Thor::MalformattedArgumentError do
      task.update_progress(51)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 50, but got '51'", e.message)
  end

  def test_updating_progress_to_100_percent_marks_task_as_complete
    task = Task.new(4, "Some task name", 20)
    updated_task = task.update_progress(100)

    assert updated_task.complete?
  end

  def test_updating_progress_to_size_of_task_marks_task_as_complete
    task = Task.new(6, "Some task name", 0, "some units", 14)
    updated_task = task.update_progress(14)

    assert updated_task.complete?
  end
end