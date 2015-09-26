# TODO: Split into percent vs custom unit implementations

class Progress

  attr_reader :value, :units, :size

  def initialize(value = 0, units = nil, size = nil)
    validate_progress(value, size)

    @value = value
    @units = units
    @size = size
  end

  def complete?
    @value == (@size.nil? ? 100 : @size)
  end

  def update_progress(value)
    Progress.new(value, @units, @size)
  end

  def update_units(units)
    if units.nil?
      updated_task_size = nil
    elsif @size.nil?
      updated_task_size = 100
    else
      updated_task_size = @size
    end

    if units.nil? && !@size.nil?
      updated_value = 100 * @value.to_f / @size
    else
      updated_value = @value
    end

    Progress.new(updated_value, units, updated_task_size)
  end

  def ==(o)
    o.class == self.class &&
      o.units == @units &&
      o.value == @value &&
      o.size == @size
  end

  alias_method :eql?, :==

  def hash
    [@units, @value, @size].hash
  end

  private

  def validate_progress(progress, task_size)
    task_max_progress = task_size.nil? ? 100 : task_size

    if progress < 0 || progress > task_max_progress
      raise Thor::MalformattedArgumentError.new(
        "Cannot update task. Expected progress between 0 and #{task_max_progress}, but got '#{progress}'")
    end
  end
end