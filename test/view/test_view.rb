require "minitest/autorun"
require "view/view_selector"

class TestView < Minitest::Test

  def setup
    @view_selector = ViewSelector.new
  end

  def test_renders_task_with_units
    task = MiniTest::Mock.new
    task.expect(:id, 4)
    task.expect(:name, "some name")
    task.expect(:progress, "some progress")

    view = @view_selector.add

    assert_equal("Added task 4: 'some name', some progress", view.render(task))
  end
end