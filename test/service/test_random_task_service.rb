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
    task = Task.new(1, "some title")

    assert_equal(task, @random_task_service.get_random_task([task]))
  end

  def test_random_task_is_one_of_several_tasks
    task1 = Task.new(1, "some title 1")
    task2 = Task.new(2, "some title 2")
    task3 = Task.new(3, "some title 3")

    all_tasks = [task1, task2, task3]

    random_task = @random_task_service.get_random_task(all_tasks)

    assert all_tasks.include? random_task
  end

  def test_random_selection_can_include_any_task
    task1 = Task.new(1, "some title 1")
    task2 = Task.new(2, "some title 2")
    task3 = Task.new(3, "some title 3")

    all_tasks = [task1, task2, task3]

    # TODO: Commonise task stats tests
    task_tally = {
      task1 => 0,
      task2 => 0,
      task3 => 0
    }

    number_of_tests = 100

    number_of_tests.times do
      random_task = @random_task_service.get_random_task(all_tasks)

      task_tally[random_task] = task_tally[random_task] + 1
    end

    assert task_tally[task1] > 15
    assert task_tally[task2] > 15
    assert task_tally[task3] > 15
  end

  def test_task_progress_increases_probability_of_being_picked
    task1 = Task.new(1, "some title", PercentProgress.new(0))
    task2 = Task.new(2, "other title", PercentProgress.new(90))

    all_tasks = [task1, task2]

    task_tally = {
      task1 => 0,
      task2 => 0
    }

    number_of_tests = 1000

    number_of_tests.times do
      random_task = @random_task_service.get_random_task(all_tasks)

      task_tally[random_task] = task_tally[random_task] + 1
    end

    assert task_tally[task1] > 0
    assert task_tally[task2] > 70
  end

  # TODO: Test tasks with custom units and size
end