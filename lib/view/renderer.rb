class Renderer

  def initialize
    # TODO: Inject
    @task_view_model_factory = TaskViewModelFactory.new
  end

  def render task
    view_model = @task_view_model_factory.create_view_model(task)

    [
      task.id,
      task.name,
      view_model.progress
    ]
  end
end