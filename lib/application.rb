class Application

  def initialize(database, renderer)
    @database = database
    @renderer = renderer
  end

  def list
    tasks = @database.list
    tasks.map { |t| @renderer.render(t) }
  end

  def add(task)
    @database.add(task)
    "Added '#{task}'"
  end

  def complete(task_id)
    task = @database.get(task_id)

    if task.nil?
      "No task with number #{task_id}"
    else
      @database.delete(task_id)
      "Task #{task_id} completed: \"#{task.name}\""
    end
  end

  def update(task_id, percent_done)
    # TODO: Validate presence of task
    # TODO: Validate percentage range

    if percent_done > 0
      task = @database.get(task_id)

      @database.update(task_id, percent_done)

      "#{task_id} #{task.name} #{percent_done}%"
    else
      "Cannot update task #{task_id}. Expected progress between 0 and 100, but got '#{percent_done}'"
    end
  end
end