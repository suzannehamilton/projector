class Task

  attr_reader :id
  attr_reader :name
  attr_reader :progress
  attr_reader :units
  attr_reader :size

  def initialize(id, name, progress = 0, units = nil, size = nil)
    if (!id.nil? && id <= 0)
      raise ArgumentError.new("Task ID must be nil or a positive integer, but was '#{id}'")
    end

    @id =  id
    @name = name
    @progress = progress
    @units = units
    @size = size
  end

  def complete?
    @progress == (@size.nil? ? 100 : @size)
  end

  def ==(o)
    o.class == self.class &&
      o.name == @name &&
      o.id == @id &&
      o.units == @units &&
      o.progress == @progress &&
      o.size == @size
  end

  alias_method :eql?, :==

  def hash
    [@id, @name, @units, @progress, @size].hash
  end
end