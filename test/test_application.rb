require "minitest/autorun"
require "thor"
require "application"
require "view/model_and_view"

class TestApplication < Minitest::Test

  def setup
    @database = MiniTest::Mock.new
    @view_model_factory = MiniTest::Mock.new
    @random_task_service = MiniTest::Mock.new
    @task_factory = MiniTest::Mock.new
    @application = Application.new(@database, @task_factory, @random_task_service, @view_model_factory)
  end

  def test_lists_no_tasks
    @database.expect(:list, [])

    assert_equal(ModelAndView.new([], Views::LIST), @application.list)
  end

  def test_lists_single_task
    task = Task.new(5, "Some task", 12)

    @database.expect(:list, [task])

    view_model = "task view model"
    @view_model_factory.expect(:create_view_model, view_model, [task])

    assert_equal(ModelAndView.new([view_model], Views::LIST), @application.list)
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

    assert_equal(ModelAndView.new([view_model_1, view_model_2, view_model_3], Views::LIST), @application.list)
  end

  def test_adding_a_task_to_list_adds_task_and_returns_task_details
    @task_factory.expect(:task, "new task", [nil, "Some task", 0, nil, nil])
    @database.expect(:add, "saved task", ["new task"])

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, ["saved task"])

    assert_equal(ModelAndView.new(view_model, Views::ADD), @application.add("Some task"))
    @database.verify
  end

  def test_can_add_task_with_units
    @task_factory.expect(:task, "new task", [nil, "Some task", 0, "some units", nil])
    @database.expect(:add, "saved task", ["new task"])

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, ["saved task"])

    assert_equal(ModelAndView.new(view_model, Views::ADD), @application.add("Some task", "some units"))
    @database.verify
  end

  def test_can_add_task_with_units_and_size
    @task_factory.expect(:task, "new task", [nil, "Some task", 0, "some units", 42])
    @database.expect(:add, "saved task", ["new task"])

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, ["saved task"])

    assert_equal(ModelAndView.new(view_model, Views::ADD), @application.add("Some task", "some units", 42))
    @database.verify
  end

  def test_cannot_complete_non_existent_task
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

    @view_model_factory.expect(:create_view_model, "some view model", [task])

    assert_equal(ModelAndView.new("some view model", Views::COMPLETE), @application.complete(6))

    @database.verify
  end

  def test_update_progress
    task = MiniTest::Mock.new
    updated_task = MiniTest::Mock.new

    @database.expect(:get, task, [4])
    task.expect(:nil?, false)
    task.expect(:update_progress, updated_task, [33])
    updated_task.expect(:complete?, false)
    @database.expect(:save, nil, [updated_task])

    @view_model_factory.expect(:create_view_model, "some view model", [updated_task])

    assert_equal(ModelAndView.new("some view model", Views::UPDATE), @application.update(4, 33))

    @database.verify
  end

  def test_cannot_update_non_existent_task
    @database.expect(:get, nil, [3])

    e = assert_raises Thor::InvocationError do
      @application.update(3, 20)
    end

    assert_equal("No task with number 3", e.message)
    @database.verify
  end

  def test_updating_progress_to_task_size_marks_task_as_complete
    task = MiniTest::Mock.new
    updated_task = MiniTest::Mock.new

    @database.expect(:get, task, [6])
    task.expect(:nil?, false)
    task.expect(:update_progress, updated_task, [100])
    updated_task.expect(:complete?, true)
    @database.expect(:delete, nil, [6])

    @view_model_factory.expect(:create_view_model, "some view model", [updated_task])

    assert_equal(ModelAndView.new("some view model", Views::COMPLETE), @application.update(6, 100))

    @database.verify
  end

  def test_can_update_units_of_task
    task = MiniTest::Mock.new
    updated_task = MiniTest::Mock.new

    @database.expect(:get, task, [4])
    task.expect(:nil?, false)
    task.expect(:update_units, updated_task, ["updated units"])
    @database.expect(:save, nil, [updated_task])

    @view_model_factory.expect(:create_view_model, "some view model", [updated_task])

    assert_equal(ModelAndView.new("some view model", Views::UNITS), @application.units(4, "updated units"))

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

  def test_can_update_size_of_task
    task = MiniTest::Mock.new
    updated_task = MiniTest::Mock.new

    @database.expect(:get, task, [4])
    task.expect(:nil?, false)
    task.expect(:update_size, updated_task, [30])
    updated_task.expect(:complete?, false)
    @database.expect(:save, nil, [updated_task])

    @view_model_factory.expect(:create_view_model, "some view model", [updated_task])

    assert_equal(ModelAndView.new("some view model", Views::SIZE), @application.size(4, 30))

    @database.verify
  end

  def test_cannot_update_size_of_non_existent_task
    @database.expect(:get, nil, [4])

    e = assert_raises Thor::InvocationError do
      @application.size(4, 20)
    end

    assert_equal("No task with number 4", e.message)
    @database.verify
  end

  def test_reducing_size_to_task_progress_marks_task_as_complete
    task = MiniTest::Mock.new
    updated_task = MiniTest::Mock.new

    @database.expect(:get, task, [6])
    task.expect(:nil?, false)
    task.expect(:update_size, updated_task, [20])
    updated_task.expect(:complete?, true)
    @database.expect(:delete, nil, [6])

    @view_model_factory.expect(:create_view_model, "some view model", [updated_task])

    assert_equal(ModelAndView.new("some view model", Views::COMPLETE), @application.size(6, 20))

    @database.verify
  end

  def test_gets_a_random_task_from_full_list
    all_tasks = "all tasks"
    selected_task = "some task"
    @database.expect(:list, all_tasks)
    @random_task_service.expect(:get_random_task, selected_task, [all_tasks])

    view_model = "some view model"
    @view_model_factory.expect(:create_view_model, view_model, [selected_task])

    assert_equal(ModelAndView.new(view_model, Views::RANDOM), @application.random)
  end

  def test_renders_missing_random_task_if_db_has_no_tasks
    @database.expect(:list, [])

    assert_equal(ModelAndView.new(nil, Views::RANDOM), @application.random)
  end
end