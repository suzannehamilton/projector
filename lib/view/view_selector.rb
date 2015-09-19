class ViewSelector
  def add
    # TODO: Keep static versions of these
    AddView.new
  end

  def update
    UpdateView.new
  end

  def complete
    CompleteView.new
  end

  def units
    UnitsView.new
  end

  def list
    ListView.new
  end
end

class AddView
  def render(task)
    "Added task #{task.id}: '#{task.name}', #{task.progress}"
  end
end

class UpdateView
  def render(task)
    "Updated task #{task.id}, '#{task.name}' to #{task.progress}"
  end
end

class CompleteView
  def render(task)
    "Task #{task.id} completed: \"#{task.name}\""
  end
end

class UnitsView
  def render(task)
    "Updated units of task #{task.id}, '#{task.name}' to '#{task.units}'. #{task.progress}"
  end
end

class ListView
  def render(tasks)
    tasks.map { |t| [t.id, t.name, t.progress] }
  end
end
