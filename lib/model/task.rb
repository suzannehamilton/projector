class Task

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def ==(o)
    o.class == self.class && o.name == @name
  end

  alias_method :eql?, :==

  def hash
    [@name].hash
  end
end