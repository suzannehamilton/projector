require "minitest/autorun"
require "view/model_and_view"

class TestModelAndView < Minitest::Test

  def test_can_get_model
    model_and_view = ModelAndView.new("some model", "some view")
    assert_equal("some model", model_and_view.model)
  end

  def test_can_get_view
    model_and_view = ModelAndView.new("some model", "some view")
    assert_equal("some view", model_and_view.view)
  end

  def test_rendering_renders_view_with_model
    view = MiniTest::Mock.new
    view.expect(:render, "rendered view", ["some model"])

    model_and_view = ModelAndView.new("some model", view)

    assert_equal("rendered view", model_and_view.render)
  end
end