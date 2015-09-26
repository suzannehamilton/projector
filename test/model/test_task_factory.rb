require "minitest/autorun"
require "model/task_factory"

class TestTaskFactory < Minitest::Test

  def setup
    @task_factory = TaskFactory.new
  end

  def test_creates_task_with_id_and_name
    task = @task_factory.task(5, "some task name")

    assert_equal(5, task.id)
    assert_equal("some task name", task.name)
  end

  def test_default_progress_is_zero
    task = @task_factory.task(1, "some name")

    assert_equal(0, task.progress.value)
  end

  def test_creates_task_with_progress
    task = @task_factory.task(1, "some name", 78)

    assert_equal(78, task.progress.value)
  end

  def test_default_units_are_none
    task = @task_factory.task(1, "some name")

    assert_nil(task.progress.units)
  end

  def test_creates_task_with_units
    task = @task_factory.task(1, "some name", 0, "some units")

    assert_equal("some units", task.progress.units)
  end

  def test_default_size_is_none
    task = @task_factory.task(1, "some name")

    assert_nil(task.progress.size)
  end

  # TODO: Should this be 100?
  def test_default_size_of_task_with_units_is_none
    task = @task_factory.task(1, "some name", 0, "some units")

    assert_nil(task.progress.size)
  end

  def test_creates_task_with_custom_size
    task = @task_factory.task(1, "some name", 0, "some units", 44)

    assert_equal(44, task.progress.size)
  end
end