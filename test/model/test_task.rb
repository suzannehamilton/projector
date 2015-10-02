require "minitest/autorun"
require "model/task"

class TestTask < Minitest::Test

  def test_can_get_task_id
    task = Task.new(5, "a name")
    assert_equal(5, task.id)
  end

  def test_nil_task_id_is_valid
    task = Task.new(nil, "a name")
    assert_nil(task.id)
  end

  def test_zero_task_id_is_invalid
    e = assert_raises ArgumentError do
      Task.new(0, "some name")
    end

    assert(e.message.include?("0"))
  end

  def test_negative_task_id_is_invalid
    e = assert_raises ArgumentError do
      Task.new(-1, "some name")
    end

    assert(e.message.include?("-1"))
  end

  def test_can_get_task_name
    task = Task.new(3, "some name")
    assert_equal("some name", task.name)
  end

  def test_name_must_be_present
    e = assert_raises ArgumentError do
      Task.new(5, nil)
    end

    assert(e.message.include?("name"))
  end

  def test_can_get_progress
    task = Task.new(4, "some name", CustomProgress.new("some units", 60, 200))
    assert_equal(CustomProgress.new("some units", 60, 200), task.progress)
  end

  def test_default_progress_is_zero
    task = Task.new(4, "some name")
    assert_equal(PercentProgress.new(0), task.progress)
  end

  def test_task_is_not_complete_when_progress_is_not_complete
    progress = MiniTest::Mock.new
    progress.expect(:complete?, false)
    task = Task.new(1, "some name", progress)
    refute task.complete?
  end

  def test_task_is_complete_when_progress_is_complete
    progress = MiniTest::Mock.new
    progress.expect(:complete?, true)
    task = Task.new(1, "some name", progress)
    assert task.complete?
  end

  def test_updating_progress_preserves_other_fields
    task = Task.new(4, "some name", CustomProgress.new("some units", 0, 90))
    updated_task = task.update_progress(82)

    assert_equal(4, updated_task.id)
    assert_equal("some name", updated_task.name)
  end

  def test_can_update_progress_of_task
    progress = MiniTest::Mock.new
    task = Task.new(5, "some name", progress)

    progress.expect(:update_progress, "updated progress", [80])

    updated_task = task.update_progress(80)

    assert_equal("updated progress", updated_task.progress)
  end

  def test_updating_custom_units_preserves_other_fields
    task = Task.new(4, "some name", CustomProgress.new("original units", 30, 90))
    updated_task = task.update_units("other units")

    assert_equal(4, updated_task.id)
    assert_equal("some name", updated_task.name)
  end

  def test_can_update_units
    original_progress = MiniTest::Mock.new
    task = Task.new(5, "some name", original_progress)

    original_progress.expect(:update_units, "updated progress", ["new units"])

    updated_task = task.update_units("new units")

    assert_equal("updated progress", updated_task.progress)
  end

  def test_can_remove_units
    original_progress = MiniTest::Mock.new
    task = Task.new(5, "some name", original_progress)

    original_progress.expect(:update_units, "updated progress", [nil])

    updated_task = task.update_units(nil)

    assert_equal("updated progress", updated_task.progress)
  end

  def test_can_update_size
    original_progress = MiniTest::Mock.new
    task = Task.new(5, "some name", original_progress)

    original_progress.expect(:update_size, "updated progress", [12])

    updated_task = task.update_size(12)

    assert_equal("updated progress", updated_task.progress)
  end
end