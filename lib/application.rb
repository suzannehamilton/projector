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
    task = get_task(task_id)

    @database.delete(task_id)

    "Task #{task_id} completed: \"#{task.name}\""
  end

  def update(task_id, percent_done)
    validate_percent_done(percent_done)

    task = get_task(task_id)

    @database.update(task_id, percent_done)

    "Updated task #{task_id}, '#{task.name}' to #{percent_done}%"
  end

  private

  def get_task(task_id)
    task = @database.get(task_id)

    if task.nil?
      raise Thor::MalformattedArgumentError.new("No task with number #{task_id}")
    else
      task
    end
  end

  def validate_percent_done(percent_done)
    if percent_done < 0 || percent_done > 100
      raise Thor::MalformattedArgumentError.new(
        "Cannot update task. Expected progress between 0 and 100, but got '#{percent_done}'")
    end
  end
end