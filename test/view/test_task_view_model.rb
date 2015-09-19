require "minitest/autorun"
require "view/task_view_model"

class TestTaskViewModel < Minitest::Test

  def setup
    @view_model_factory = TaskViewModelFactory.new
  end

  def test_id_is_nil_if_task_has_no_id
    task = Task.new(nil, "some name", 0)
    view_model = @view_model_factory.create_view_model(task)
    assert_nil(view_model.id)
  end

  def test_id_is_task_id
    task = Task.new(4, "some name", 0)
    view_model = @view_model_factory.create_view_model(task)
    assert_equal(4, view_model.id)
  end

  def test_name_is_task_name
    task = Task.new(4, "some name", 0)
    view_model = @view_model_factory.create_view_model(task)
    assert_equal("some name", view_model.name)
  end

  def test_task_with_no_units_renders_zero_percent_complete
    task = Task.new(7, "Saved task name", 0)

    view_model = @view_model_factory.create_view_model(task)

    assert_equal("0% complete", view_model.progress)
  end

  def test_task_with_no_units_renders_percent_complete
    task = Task.new(4, "Saved task name", 32)

    view_model = @view_model_factory.create_view_model(task)

    assert_equal("32% complete", view_model.progress)
  end

  def test_task_with_units_renders_zero_percent_and_progress
    task = Task.new(7, "Saved task name", 0, "some units")

    view_model = @view_model_factory.create_view_model(task)

    assert_equal("0% complete (0/100 some units)", view_model.progress)
  end

  def test_task_with_units_renders_percent_and_progress
    task = Task.new(7, "Saved task name", 89, "some units")

    view_model = @view_model_factory.create_view_model(task)

    assert_equal("89% complete (89/100 some units)", view_model.progress)
  end

  def test_new_task_with_custom_displays_zero_progress_as_zero_percent
    task = Task.new(7, "Saved task name", 0, "some units", 59)

    view_model = @view_model_factory.create_view_model(task)

    assert_equal("0% complete (0/59 some units)", view_model.progress)
  end

  def test_new_task_with_custom_units_calculated_percent
    task = Task.new(7, "Saved task name", 2, "some units", 4)

    view_model = @view_model_factory.create_view_model(task)

    assert_equal("50% complete (2/4 some units)", view_model.progress)
  end

  # TODO: Test task with non-integer progress (test rounding)
  # TODO: Parameterise tests of progress?

  def test_default_units_are_percent
    task = Task.new(7, "Saved task name", 89)

    view_model = @view_model_factory.create_view_model(task)

    assert_equal("percent", view_model.units)
  end

  def test_custom_units_are_rendered_as_given
    task = Task.new(7, "Saved task name", 89, "some units")

    view_model = @view_model_factory.create_view_model(task)

    assert_equal("some units", view_model.units)
  end

  # TODO: Test progress which is not out of 100
end