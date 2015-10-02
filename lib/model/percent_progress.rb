class PercentProgress

  attr_reader :value

  def initialize(value = 0)
    validate_progress(value)

    @value = value
  end

  def units
    nil
  end

  def size
    nil
  end

  def complete?
    @value == 100
  end

  def percent_done
    @value.round
  end

  def update_progress(new_progress)
    PercentProgress.new(new_progress)
  end

  def update_units(new_units)
    if new_units.nil?
      self
    else
      CustomProgress.new(new_units, @value)
    end
  end

  def update_size(size)
    raise Thor::InvocationError.new("Cannot update size of task with no units")
  end

  def ==(o)
    o.class == self.class &&
      o.value == @value
  end

  alias_method :eql?, :==

  def hash
    @value.hash
  end

  private

  def validate_progress(progress)
    if progress < 0 || progress > 100
      raise Thor::MalformattedArgumentError.new(
        "Cannot update task. Expected progress between 0 and #{100}, but got '#{progress}'")
    end
  end
end