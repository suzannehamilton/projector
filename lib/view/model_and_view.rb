class ModelAndView

  attr_reader :model, :view

  def initialize(model, view)
    @model = model
    @view = view
  end

  def render
    @view.render(@model)
  end

  def ==(o)
    o.class == self.class &&
      o.model == @model &&
      o.view == @view
  end

  alias_method :eql?, :==

  def hash
    [@model, @view].hash
  end
end