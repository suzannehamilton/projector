class Task

  attr_reader :id
  attr_reader :name
  attr_reader :progress

  def initialize(id, name, progress = Progress.new)
    validate_id(id)
    validate_name(name)

    @id =  id
    @name = name
    @progress = progress
  end

  def complete?
    @progress.complete?
  end

  def update_progress(progress)
    Task.new(@id, @name, @progress.update_progress(progress))
  end

  def update_units(units)
    Task.new(@id, @name, @progress.update_units(units))
  end

  def ==(o)
    o.class == self.class &&
      o.name == @name &&
      o.id == @id &&
      o.progress == @progress
  end

  alias_method :eql?, :==

  def hash
    [@id, @name, @progress].hash
  end

  private

  def validate_id(id)
    if (!id.nil? && id <= 0)
      raise ArgumentError.new("Task ID must be nil or a positive integer, but was '#{id}'")
    end
  end

  def validate_name(name)
    if (name.nil?)
      raise ArgumentError.new("Task name must not be nil")
    end
  end
end