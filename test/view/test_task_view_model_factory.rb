require "minitest/autorun"
require "view/task_view_model_factory"

class TestTaskViewModelFactory < Minitest::Test

  def setup
    @view_model_factory = TaskViewModelFactory.new
  end

  def test_task_with_no_units_just_list_percent_complete
    task = Task.new(7, "Saved task name", 0)

    view_model = @view_model_factory.create_view_model(task)

    assert_equal("0% complete", view_model.progress)
  end

  def test_task_with_units_renders_percent_and_progress
    task = Task.new(7, "Saved task name", 0, "some units")

    view_model = @view_model_factory.create_view_model(task)

    assert_equal("0% complete (0/100 some units)", view_model.progress)
  end

  # TODO: Test non-zero progress
  # TODO: Test progress which is not out of 100
end