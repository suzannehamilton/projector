class Renderer

  def render task
    [task.id.to_s, task.name, "0%"]
  end
end