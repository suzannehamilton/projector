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
    progress = @task.units.nil? ? "" : " (#{@task.progress}/#{size} #{@task.units})"
    "#{@task.progress}% complete" + progress
  end

  def units
    @task.units.nil? ? "percent" : "#{@task.units}"
  end
end