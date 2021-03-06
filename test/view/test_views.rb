require "minitest/autorun"
require "view/views"

class TestView < Minitest::Test

  def test_renders_added_task
    task = MiniTest::Mock.new
    task.expect(:id, 4)
    task.expect(:name, "some name")
    task.expect(:progress, "some progress")

    view = Views::ADD

    assert_equal("Added task 4: 'some name', some progress", view.render(task))
  end

  def test_renders_updated_task
    task = MiniTest::Mock.new
    task.expect(:id, 4)
    task.expect(:name, "some name")
    task.expect(:progress, "some progress")

    view = Views::UPDATE

    assert_equal("Updated task 4, 'some name' to some progress", view.render(task))
  end

  def test_renders_completed_task
    task = MiniTest::Mock.new
    task.expect(:id, 6)
    task.expect(:name, "some name")

    view = Views::COMPLETE

    assert_equal("Task 6 completed: \"some name\"", view.render(task))
  end

  def test_renders_units_update
    task = MiniTest::Mock.new
    task.expect(:id, 3)
    task.expect(:name, "some name")
    task.expect(:units, "some units")
    task.expect(:progress, "some progress")

    view = Views::UNITS

    assert_equal(
      "Updated units of task 3, 'some name' to 'some units'. some progress",
      view.render(task))
  end

  def test_renders_size_update
    task = MiniTest::Mock.new
    task.expect(:id, 3)
    task.expect(:name, "some name")
    task.expect(:size, 40)
    task.expect(:progress, "some progress")

    view = Views::SIZE

    assert_equal(
      "Updated size of task 3, 'some name', to 40. some progress",
      view.render(task))
  end

  def test_renders_empty_task_list
    view = Views::LIST

    assert_equal([["Nothing left to do!"]], view.render([]))
  end

  def test_renders_single_task
    task = MiniTest::Mock.new
    task.expect(:id, 5)
    task.expect(:name, "Some task")
    task.expect(:progress, "task progress")

    view = Views::LIST

    assert_equal([
      ["id", "name", "progress"], [5, "Some task", "task progress"]],
      view.render([task]))
  end

  def test_renders_multiple_tasks
    task_1 = MiniTest::Mock.new
    task_1.expect(:id, 1)
    task_1.expect(:name, "task 1")
    task_1.expect(:progress, "task 1 progress")

    task_2 = MiniTest::Mock.new
    task_2.expect(:id, 2)
    task_2.expect(:name, "task 2")
    task_2.expect(:progress, "task 2 progress")

    view = Views::LIST

    assert_equal(
      [["id", "name", "progress"], [1, "task 1", "task 1 progress"], [2, "task 2", "task 2 progress"]],
      view.render([task_1, task_2]))
  end

  def test_renders_random_task
    task = MiniTest::Mock.new
    task.expect(:nil?, false)
    task.expect(:id, 5)
    task.expect(:name, "Task Name")
    task.expect(:progress, "task progress")

    view = Views::RANDOM

    assert_equal("5, Task Name, task progress", view.render(task))
  end

  def test_displays_nothing_left_to_do_notice_if_no_random_task_can_be_selected
    assert_equal("Nothing left to do!", Views::RANDOM.render(nil))
  end
end