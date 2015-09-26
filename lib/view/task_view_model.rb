class TaskViewModelFactory

  def create_view_model(task)
    return TaskViewModel.new(task)
  end
end

class TaskViewModel

  def initialize(task)
    @task = task
  end

  def id
    @task.id
  end

  def name
    @task.name
  end

  def progress
    size = @task.progress.size.nil? ? 100 : @task.progress.size
    # TODO: Push onto Task? Or Progress class within Task?
    percent_done = (100 * @task.progress.value.to_f / size).round
    progress = @task.progress.units.nil? ? "" : " (#{@task.progress.value}/#{size} #{@task.progress.units})"
    "#{percent_done}% complete" + progress
  end

  def units
    @task.progress.units.nil? ? "percent" : "#{@task.progress.units}"
  end
end