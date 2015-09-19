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
