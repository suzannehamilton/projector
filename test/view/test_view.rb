require "minitest/autorun"
require "view/view_selector"

class TestView < Minitest::Test

  def setup
    @view_selector = ViewSelector.new
  end

  def test_renders_added_task
    task = MiniTest::Mock.new
    task.expect(:id, 4)
    task.expect(:name, "some name")
    task.expect(:progress, "some progress")

    view = @view_selector.add

    assert_equal("Added task 4: 'some name', some progress", view.render(task))
  end

  def test_renders_updated_task
    task = MiniTest::Mock.new
    task.expect(:id, 4)
    task.expect(:name, "some name")
    task.expect(:progress, "some progress")

    view = @view_selector.update

    assert_equal("Updated task 4, 'some name' to some progress", view.render(task))
  end

  def test_renders_completed_task
    task = MiniTest::Mock.new
    task.expect(:id, 6)
    task.expect(:name, "some name")

    view = @view_selector.complete

    assert_equal("Task 6 completed: \"some name\"", view.render(task))
  end

  def test_renders_units_update
    task = MiniTest::Mock.new
    task.expect(:id, 3)
    task.expect(:name, "some name")
    task.expect(:units, "some units")
    task.expect(:progress, "some progress")

    view = @view_selector.units

    assert_equal(
      "Updated units of task 3, 'some name' to 'some units'. some progress",
      view.render(task))
  end
end