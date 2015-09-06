class Renderer

  def render task
    [
      task.id.to_s,
      task.name,
      # TODO: Commonise with units in add task
      "#{task.percent_done}%" + (task.units.nil? ? "" : " (#{task.percent_done}/100 #{task.units})")
    ]
  end
end