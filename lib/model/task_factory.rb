require_relative 'percent_progress'
require_relative 'custom_progress'

class TaskFactory

  def task(id, name, progress_value = 0, units = nil, size = nil)
    validate_units_and_size(units, size)

    if units.nil?
      progress = PercentProgress.new(progress_value)
    else
      progress = CustomProgress.new(units, progress_value, (size.nil? ? 100 : size))
    end

    Task.new(id, name, progress)
  end

  def validate_units_and_size(units, size)
    if units.nil? && !size.nil?
      raise Thor::MalformattedArgumentError.new(
        "Cannot create a task with size but not units. Size given was '#{size}.'")
    end
  end
end