require_relative 'percent_progress'
require_relative 'custom_progress'

class TaskFactory

  # TODO: Remove defaults from Task once they're all on TaskFactory?
  def task(id, name, progress_value = 0, units = nil, size = nil)
    # TODO: Validate that size is nil if units are nil
    if units.nil?
      progress = PercentProgress.new(progress_value)
    else
      progress = CustomProgress.new(units, progress_value, (size.nil? ? 100 : size))
    end

    Task.new(id, name, progress)
  end
end