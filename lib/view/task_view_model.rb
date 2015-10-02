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

  def size
    @task.progress.size
  end

  def progress
    units = @task.progress.units
    progress = units.nil? ? "" : " (#{@task.progress.value}/#{@task.progress.size} #{units})"
    "#{@task.progress.percent_done}% complete" + progress
  end

  def units
    @task.progress.units.nil? ? "percent" : "#{@task.progress.units}"
  end
end