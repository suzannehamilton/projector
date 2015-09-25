class TaskFactory

  # TODO: Remove defaults from Task once they're all on TaskFactory?
  def task(id, name, progress = 0, units = nil, size = nil)
    Task.new(id, name, progress, units, size)
  end
end