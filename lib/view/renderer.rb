class Renderer

  def initialize(task_view_model_factory)
    @task_view_model_factory = task_view_model_factory
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