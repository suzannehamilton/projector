class Task

  attr_reader :id
  attr_reader :name
  attr_reader :progress
  attr_reader :units
  attr_reader :size

  def initialize(id, name, progress = 0, units = nil, size = nil)
    validate_id(id)
    validate_name(name)
    validate_progress(progress, size)

    @id =  id
    @name = name
    @progress = progress
    @units = units
    @size = size
  end

  def complete?
    @progress == (@size.nil? ? 100 : @size)
  end

  def update_progress(progress)
    Task.new(@id, @name, progress, @units, @size)
  end

  def update_units(units)
    if units.nil?
      updated_task_size = nil
    elsif @size.nil?
      updated_task_size = 100
    else
      updated_task_size = @size
    end

    updated_task = Task.new(@id, @name, @progress, units, updated_task_size)
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

  def validate_progress(progress, task_size)
    task_max_progress = task_size.nil? ? 100 : task_size

    if progress < 0 || progress > task_max_progress
      raise Thor::MalformattedArgumentError.new(
        "Cannot update task. Expected progress between 0 and #{task_max_progress}, but got '#{progress}'")
    end
  end
end