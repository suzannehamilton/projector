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

  class ProgressValues
    attr_reader :value, :size, :percent

    def initialize(value, size, percent)
      @value = value
      @size = size
      @percent = percent
    end
  end

  percent_combinations = [
    ProgressValues.new(0, 100, 0),
    ProgressValues.new(42, 100, 42),
    ProgressValues.new(100, 100, 100),
    ProgressValues.new(23.467, 100, 23),
    ProgressValues.new(23.5, 100, 24),
    ProgressValues.new(23.84457, 100, 24)
  ]

  percent_combinations.each do |p|
    define_method("test_task_in_percent_and_progress_#{p.value}_is_#{p.percent}_percent_complete") do
      task = Task.new(1, "some name", Progress.new(p.value))

      view_model = @view_model_factory.create_view_model(task)

      assert_equal("#{p.percent}% complete", view_model.progress)
    end

    define_method("test_task_with_default_size_and_progress_#{p.value}_is_#{p.percent}_percent_complete") do
      task = Task.new(1, "some name", Progress.new(p.value, "some units"))

      view_model = @view_model_factory.create_view_model(task)

      assert_equal("#{p.percent}% complete (#{p.value}/100 some units)", view_model.progress)
    end
  end

  progress_combinations = [
    ProgressValues.new(0, 100, 0),
    ProgressValues.new(1, 100, 1),
    ProgressValues.new(13, 100, 13),
    ProgressValues.new(100, 100, 100),
    ProgressValues.new(0, 12, 0),
    ProgressValues.new(3, 12, 25),
    ProgressValues.new(12, 12, 100),
    ProgressValues.new(58.346, 100, 58),
    ProgressValues.new(58.5, 100, 59),
    ProgressValues.new(3, 9, 33),
    ProgressValues.new(6, 9, 67),
    ProgressValues.new(13.578, 16.467, 82)
  ]

  progress_combinations.each do |p|
    define_method("test_task_with_size_#{p.size}_and_progress_#{p.value}_is_#{p.percent}_percent_complete") do
      task = Task.new(1, "some name", Progress.new(p.value, "some units", p.size))

      view_model = @view_model_factory.create_view_model(task)

      assert_equal("#{p.percent}% complete (#{p.value}/#{p.size} some units)", view_model.progress)
    end
  end

  def test_default_units_are_percent
    task = Task.new(7, "Saved task name", Progress.new(89))

    view_model = @view_model_factory.create_view_model(task)

    assert_equal("percent", view_model.units)
  end

  def test_custom_units_are_rendered_as_given
    task = Task.new(7, "Saved task name", Progress.new(89, "some units"))

    view_model = @view_model_factory.create_view_model(task)

    assert_equal("some units", view_model.units)
  end
end
