class Task

  attr_reader :id
  attr_reader :name
  attr_reader :percent_done
  attr_reader :units

  def initialize(id, name, percent_done, units = nil)
    if (!id.nil? && id <= 0)
      raise ArgumentError.new("Task ID must be nil or a positive integer, but was '#{id}'")
    end

    @id =  id
    @name = name
    @percent_done = percent_done
    @units = units
  end

  def ==(o)
    o.class == self.class &&
      o.name == @name &&
      o.id == @id &&
      o.units == @units
  end

  alias_method :eql?, :==

  def hash
    [@id, @name, @units].hash
  end
end