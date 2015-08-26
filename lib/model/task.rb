class Task

  attr_reader :id
  attr_reader :name
  attr_reader :percent_done

  def initialize(id, name, percent_done)
    @id =  id
    @name = name
    @percent_done = percent_done
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