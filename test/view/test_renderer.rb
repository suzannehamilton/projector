require "minitest/autorun"
require "view/renderer"

class TestRenderer < Minitest::Test

  def setup
    @renderer = Renderer.new
  end

  def test_renders_task
    assert_equal(["5", "Some task", "12%"], @renderer.render(Task.new(5, "Some task", 12)))
  end
end