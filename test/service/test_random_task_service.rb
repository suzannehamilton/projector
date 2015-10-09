require "service/random_task_service"
require "minitest/autorun"

class TestRandomTaskService < Minitest::Test

  def setup
    @random_task_service = RandomTaskService.new
  end

  def test_random_task_is_nil_when_there_are_no_tasks
    assert_nil @random_task_service.get_random_task([])
  end

  def test_random_task_is_only_task
    task = "some task"

    assert_equal(task, @random_task_service.get_random_task([task]))
  end

  def test_random_task_is_one_of_several_tasks
    task1 = "some task 1"
    task2 = "some task 2"
    task3 = "some task 3"

    all_tasks = [task1, task2, task3]

    random_task = @random_task_service.get_random_task(all_tasks)

    assert all_tasks.include? random_task
  end

  # TODO: Test random selection
end