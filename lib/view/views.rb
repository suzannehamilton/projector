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
    if tasks.empty?
      # TODO: Find a better way of rendering a message vs a table
      [["Nothing left to do!"]]
    else
      rendered_tasks = tasks.map { |t| [t.id, t.name, t.progress] }
      [["id", "name", "progress"]].concat(rendered_tasks)
    end
  end
end

class Views
  ADD = AddView.new
  LIST = ListView.new
  COMPLETE = CompleteView.new
  UPDATE = UpdateView.new
  UNITS = UnitsView.new
end
