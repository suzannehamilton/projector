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
    "0% complete" + (@task.units.nil? ? "" : " (0/100 #{@task.units})")
  end
end