class Task

  attr_reader :id
  attr_reader :name
  attr_reader :progress
  attr_reader :units

  def initialize(id, name, progress, units = nil)
    if (!id.nil? && id <= 0)
      raise ArgumentError.new("Task ID must be nil or a positive integer, but was '#{id}'")
    end

    @id =  id
    @name = name
    @progress = progress
    @units = units
  end

  def ==(o)
    o.class == self.class &&
      o.name == @name &&
      o.id == @id &&
      o.units == @units &&
      o.progress == @progress
  end

  alias_method :eql?, :==

  def hash
    [@id, @name, @units, @progress].hash
  end
end