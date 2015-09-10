require "minitest/autorun"
require "view/renderer"

class TestRenderer < Minitest::Test

  def setup
    @view_model_factory = MiniTest::Mock.new
    @renderer = Renderer.new(@view_model_factory)
  end

  def test_renders_task
    task = Task.new(5, "Some task", 12)

    view_model = MiniTest::Mock.new
    view_model.expect(:progress, "task progress")
    @view_model_factory.expect(:create_view_model, view_model, [task])

    assert_equal([5, "Some task", "task progress"], @renderer.render(task))
  end
end