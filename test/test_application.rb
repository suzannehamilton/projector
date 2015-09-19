require "minitest/autorun"
require "thor"
require "application"

class TestApplication < Minitest::Test

  def setup
    @database = MiniTest::Mock.new
    @view_selector = MiniTest::Mock.new
    @view_model_factory = MiniTest::Mock.new
    @application = Application.new(@database, @view_selector, @view_model_factory)
  end

  def test_lists_no_tasks
    @database.expect(:list, [])

    view = MiniTest::Mock.new
    @view_selector.expect(:list, view)

    view.expect(:render, "rendered task list", [[]])

    assert_equal("rendered task list", @application.list)
  end

  def test_lists_single_task
    task = Task.new(5, "Some task", 12)

    @database.expect(:list, [task])

    view_model = "task view model"
    @view_model_factory.expect(:create_view_model, view_model, [task])

    view = MiniTest::Mock.new
    @view_selector.expect(:list, view)
    view.expect(:render, "rendered task list", [["task view model"]])

    assert_equal("rendered task list", @application.list)
  end

  def test_lists_multiple_tasks
    task1 = Task.new(3, "some task", 0)
    task2 = Task.new(7, "another task", 98)
    task3 = Task.new(8, "some other task", 34)

    @database.expect(:list, [task1, task2, task3])

    view_model_1 = "task view model 1"
    view_model_2 = "task view model 1"
    view_model_3 = "task view model 1"
    @view_model_factory.expect(:create_view_model, view_model_1, [task1])
    @view_model_factory.expect(:create_view_model, view_model_2, [task2])
    @view_model_factory.expect(:create_view_model, view_model_3, [task3])

    view = MiniTest::Mock.new
    @view_selector.expect(:list, view)
    view.expect(:render, "rendered task list", [[view_model_1, view_model_2, view_model_3]])

    assert_equal("rendered task list", @application.list)
  end

  def test_adding_a_task_to_list_adds_task_and_returns_task_details
    task = Task.new(7, "Saved task name", 0)
    @database.expect(:add, task, ["Some task", nil, nil])

    view = MiniTest::Mock.new
    @view_selector.expect(:add, view)

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, [task])

    view.expect(:render, "Rendered task", [view_model])

    assert_equal("Rendered task", @application.add("Some task"))
    @database.verify
  end

  def test_can_add_task_with_units
    task = Task.new(7, "Saved task name", 0, "some units")
    @database.expect(:add, task, ["Some task", "some units", nil])

    view = MiniTest::Mock.new
    @view_selector.expect(:add, view)

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, [task])

    view.expect(:render, "Rendered task", [view_model])

    assert_equal("Rendered task", @application.add("Some task", "some units"))
    @database.verify
  end

  # TODO: Test that size cannot be specified when creating a task without units

  def test_can_add_task_with_units_and_size
    task = Task.new(4, "Saved task name", 0, "some units", 42)
    # TODO: Should :add just take a Task?
    @database.expect(:add, task, ["Some task", "some units", 42])

    view = MiniTest::Mock.new
    @view_selector.expect(:add, view)

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, [task])

    view.expect(:render, "Rendered task", [view_model])

    assert_equal("Rendered task", @application.add("Some task", "some units", 42))
    @database.verify
  end

  def test_cannot_remove_non_existent_task
    @database.expect(:get, nil, [4])

    e = assert_raises Thor::InvocationError do
      @application.complete(4)
    end

    assert_equal("No task with number 4", e.message)

    @database.verify
  end

  def test_can_complete_a_task
    task = Task.new(6, "Shear the sheep", 55)
    @database.expect(:get, task, [6])
    @database.expect(:delete, nil, [6])

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, [task])

    view = MiniTest::Mock.new
    @view_selector.expect(:complete, view)
    view.expect(:render, "Rendered task", [view_model])

    assert_equal("Rendered task", @application.complete(6))

    @database.verify
  end

  def test_update_progress
    @database.expect(:get, Task.new(4, "Some task name", 20), [4])
    updated_task = Task.new(4, "Some task name", 33)
    @database.expect(:save, nil, [updated_task])

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, [updated_task])

    view = MiniTest::Mock.new
    @view_selector.expect(:update, view)
    view.expect(:render, "Rendered task", [view_model])

    assert_equal("Rendered task", @application.update(4, 33))

    @database.verify
  end

  def test_updating_progress_of_task_with_custom_size_preserves_size
    @database.expect(:get, Task.new(4, "Some task name", 20, "some units", 60), [4])
    updated_task = Task.new(4, "Some task name", 33, "some units", 60)
    @database.expect(:save, nil, [updated_task])

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, [updated_task])

    view = MiniTest::Mock.new
    @view_selector.expect(:update, view)
    view.expect(:render, "Rendered task", [view_model])

    assert_equal("Rendered task", @application.update(4, 33))

    @database.verify
  end

  def test_update_zero_percentage
    @database.expect(:get, Task.new(4, "Some task name", 20), [4])
    updated_task = Task.new(4, "Some task name", 0)
    @database.expect(:save, nil, [updated_task])

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, [updated_task])

    view = MiniTest::Mock.new
    @view_selector.expect(:update, view)
    view.expect(:render, "Rendered task", [view_model])

    assert_equal("Rendered task", @application.update(4, 0))

    @database.verify
  end

  def test_progress_cannot_be_negative
    @database.expect(:get, Task.new(4, "some name", 0), [4])

    e = assert_raises Thor::MalformattedArgumentError do
      @application.update(4, -12)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 100, but got '-12'", e.message)
  end

  def test_percent_done_cannot_be_more_than_100_percent
    @database.expect(:get, Task.new(7, "some name", 0), [7])

    e = assert_raises Thor::MalformattedArgumentError do
      @application.update(7, 101)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 100, but got '101'", e.message)
  end

  def test_progress_of_custom_size_task_cannot_be_negative
    @database.expect(:get, Task.new(3, "some name", 20, "some units", 50), [3])

    e = assert_raises Thor::MalformattedArgumentError do
      @application.update(3, -2)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 50, but got '-2'", e.message)
  end

  def test_progress_of_custom_size_task_cannot_be_more_than_task_size
    @database.expect(:get, Task.new(3, "some name", 0, "some units", 50), [3])

    e = assert_raises Thor::MalformattedArgumentError do
      @application.update(3, 51)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 50, but got '51'", e.message)
  end

  def test_cannot_update_non_existent_task
    @database.expect(:get, nil, [3])

    e = assert_raises Thor::InvocationError do
      @application.update(3, 20)
    end

    assert_equal("No task with number 3", e.message)
    @database.verify
  end

  def test_updating_progress_to_100_percent_marks_task_as_complete
    task = Task.new(6, "Shear the sheep", 55)
    @database.expect(:get, task, [6])
    @database.expect(:delete, nil, [6])

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, [task])

    view = MiniTest::Mock.new
    @view_selector.expect(:complete, view)
    view.expect(:render, "Rendered task", [view_model])

    assert_equal("Rendered task", @application.update(6, 100))

    @database.verify
  end

  def test_can_update_units_of_task_with_no_progress
    @database.expect(:get, Task.new(4, "Task name", 0), [4])
    updated_task = Task.new(4, "Task name", 0, "updated units")
    @database.expect(:save, nil, [updated_task])

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, [updated_task])

    view = MiniTest::Mock.new
    @view_selector.expect(:units, view)
    view.expect(:render, "Rendered task", [view_model])

    assert_equal("Rendered task", @application.units(4, "updated units"))

    @database.verify
  end

  def test_can_update_units_of_task_in_progress
    @database.expect(:get, Task.new(4, "Task name", 80), [4])
    updated_task = Task.new(4, "Task name", 80, "updated units")
    @database.expect(:save, nil, [updated_task])

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, [updated_task])

    view = MiniTest::Mock.new
    @view_selector.expect(:units, view)
    view.expect(:render, "Rendered task", [view_model])

    assert_equal("Rendered task", @application.units(4, "updated units"))

    @database.verify
  end

  def test_can_update_units_of_task_with_custom_size
    @database.expect(:get, Task.new(4, "Task name", 80, "original units", 152), [4])
    updated_task = Task.new(4, "Task name", 80, "updated units", 152)
    @database.expect(:save, nil, [updated_task])

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, [updated_task])

    view = MiniTest::Mock.new
    @view_selector.expect(:units, view)
    view.expect(:render, "Rendered task", [view_model])

    assert_equal("Rendered task", @application.units(4, "updated units"))

    @database.verify
  end

  def test_no_units_converts_units_to_percent
    @database.expect(:get, Task.new(4, "Task name", 0, "original units"), [4])
    updated_task = Task.new(4, "Task name", 0)
    @database.expect(:save, nil, [updated_task])

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, [updated_task])

    view = MiniTest::Mock.new
    @view_selector.expect(:units, view)
    view.expect(:render, "Rendered task", [view_model])

    assert_equal("Rendered task", @application.units(4, nil))

    @database.verify
  end

  def test_no_units_and_custom_size_converts_units_to_100_percent
    @database.expect(:get, Task.new(4, "Task name", 0, "original units", 30), [4])
    updated_task = Task.new(4, "Task name", 0)
    @database.expect(:save, nil, [updated_task])

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, [updated_task])

    view = MiniTest::Mock.new
    @view_selector.expect(:units, view)
    view.expect(:render, "Rendered task", [view_model])

    assert_equal("Rendered task", @application.units(4, nil))

    @database.verify
  end

  def test_cannot_update_units_of_non_existent_task
    @database.expect(:get, nil, [4])

    e = assert_raises Thor::InvocationError do
      @application.units(4, "updated units")
    end

    assert_equal("No task with number 4", e.message)
    @database.verify
  end

  # TODO: Test that size cannot be updated when units are not percent
end