class ViewSelector
  def add
    # TODO: Keep static versions of these
    AddView.new
  end
end

class AddView
  def render(task)
    "Added task #{task.id}: '#{task.name}', #{task.progress}"
  end
end
