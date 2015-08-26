class Renderer

  def render task
    [task.id.to_s, task.name, "#{task.percent_done}%"]
  end
end