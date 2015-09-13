class TaskViewModelFactory

  def create_view_model(task)
    return TaskViewModel.new(task)
  end
end

class TaskViewModel

  def initialize(task)
    @task = task
  end

  def progress
    size = @task.size.nil? ? 100 : @task.size
    # TODO: Push onto Task? Or Progress class within Task?
    percent_done = (100 * @task.progress.to_f / size).to_i
    progress = @task.units.nil? ? "" : " (#{@task.progress}/#{size} #{@task.units})"
    "#{percent_done}% complete" + progress
  end

  def units
    @task.units.nil? ? "percent" : "#{@task.units}"
  end
end