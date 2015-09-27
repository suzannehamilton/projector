class CustomProgress

  attr_reader :units, :value, :size

  def initialize(units, value = 0, size = 100)
    validate_progress(value, size)

    @units = units
    @value = value
    @size = size
  end

  def complete?
    @value == @size
  end

  def update_progress(new_progress)
    CustomProgress.new(@units, new_progress, @size)
  end

  def update_units(new_units)
    if new_units.nil?
      updated_value = 100 * @value.to_f / @size
      PercentProgress.new(updated_value)
    else
      CustomProgress.new(new_units, @value, @size)
    end
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
    if progress < 0 || progress > task_size
      raise Thor::MalformattedArgumentError.new(
        "Cannot update task. Expected progress between 0 and #{task_size}, but got '#{progress}'")
    end
  end
end