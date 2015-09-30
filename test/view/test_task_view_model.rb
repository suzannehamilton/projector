require "minitest/autorun"
require "view/task_view_model"

class TestTaskViewModel < Minitest::Test

  def setup
    @view_model_factory = TaskViewModelFactory.new
  end

  def test_id_is_nil_if_task_has_no_id
    task = Task.new(nil, "some name")
    view_model = @view_model_factory.create_view_model(task)
    assert_nil(view_model.id)
  end

  def test_id_is_task_id
    task = Task.new(4, "some name")
    view_model = @view_model_factory.create_view_model(task)
    assert_equal(4, view_model.id)
  end

  def test_name_is_task_name
    task = Task.new(4, "some name")
    view_model = @view_model_factory.create_view_model(task)
    assert_equal("some name", view_model.name)
  end

  def test_progress_is_just_percentage_if_task_has_no_units
    progress = MiniTest::Mock.new
    progress.expect(:units, nil)
    progress.expect(:percent_done, 43)

    task = Task.new(1, "some name", progress)

    view_model = @view_model_factory.create_view_model(task)

    assert_equal("43% complete", view_model.progress)
  end

  def test_progress_contains_size_if_task_has_units
    progress = MiniTest::Mock.new
    progress.expect(:units, "some units")
    progress.expect(:size, 50)
    progress.expect(:value, 1)
    progress.expect(:percent_done, 88)

    task = Task.new(1, "some name", progress)

    view_model = @view_model_factory.create_view_model(task)

    assert_equal("88% complete (1/50 some units)", view_model.progress)
  end

  def test_units_of_percent_progress_are_percent
    task = Task.new(7, "Saved task name", PercentProgress.new(89))

    view_model = @view_model_factory.create_view_model(task)

    assert_equal("percent", view_model.units)
  end

  def test_custom_units_are_rendered_as_given
    task = Task.new(7, "Saved task name", CustomProgress.new("some units", 89))

    view_model = @view_model_factory.create_view_model(task)

    assert_equal("some units", view_model.units)
  end
end
