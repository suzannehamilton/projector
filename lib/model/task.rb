class Task

  attr_reader :name
  attr_reader :id

  def initialize(id, name)
    @id =  id
    @name = name
  end

  def ==(o)
    o.class == self.class &&
      o.name == @name &&
      o.id == @id
  end

  alias_method :eql?, :==

  def hash
    [@id, @name].hash
  end
end