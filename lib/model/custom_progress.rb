class CustomProgress

  attr_reader :units, :value, :size

  def initialize(units, value = 0, size = 100)
    validate_size(size)
    validate_progress(value, size)

    @units = units
    @value = value
    @size = size
  end

  def complete?
    @value == @size
  end

  def percent_done
    (100 * @value.to_f / @size).round
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

  def update_size(new_size)
    CustomProgress.new(@units, @value, new_size)
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

  def validate_size(size)
    size > 0 or raise Thor::MalformattedArgumentError.new("Task size must be greater than 0, but got #{size}")
  end

  def validate_progress(progress, task_size)
    progress >= 0 or raise Thor::MalformattedArgumentError.new("Task progress must not be negative, but got #{progress}")
    progress <= task_size or raise Thor::MalformattedArgumentError.new(
      "Task progress '#{progress}' cannot be larger than task size #{task_size}")
  end
end