# TODO: Should this file be named after the view model?

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
    "#{@task.progress}% complete" + (@task.units.nil? ? "" : " (#{@task.progress}/100 #{@task.units})")
  end
end