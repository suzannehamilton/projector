class Renderer

  def render task
    [
      task.id.to_s,
      task.name,
      # TODO: Commonise with units in add task
      "#{task.progress}%" + (task.units.nil? ? "" : " (#{task.progress}/100 #{task.units})")
    ]
  end
end