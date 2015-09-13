require "minitest/autorun"
require "view/task_view_model"

class TestTaskViewModel < Minitest::Test

  def setup
    @view_model_factory = TaskViewModelFactory.new
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