require "minitest/autorun"
require "view/renderer"

class TestRenderer < Minitest::Test

  def setup
    @renderer = Renderer.new
  end

  def test_renders_task
    assert_equal([5, "Some task", "12% complete"], @renderer.render(Task.new(5, "Some task", 12)))
  end

  def test_renders_non_default_task_units
    assert_equal(
      [5, "Some task", "20% complete (20/100 some units)"],
      @renderer.render(Task.new(5, "Some task", 20, "some units")))
  end
end