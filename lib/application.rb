class Application

  def initialize(database, renderer)
    @database = database
    @renderer = renderer
  end

  def list
    tasks = @database.list

    tasks.map { |t| @renderer.render(t) }
  end

  def add(task_name)
    task = @database.add(task_name)
    "Added task #{task.id}: '#{task.name}'"
  end

  def complete(task_id)
    task = get_task(task_id)

    complete_task(task)
  end

  def update(task_id, percent_done)
    validate_percent_done(percent_done)

    task = get_task(task_id)

    if (percent_done == 100)
      complete_task(task)
    else
      @database.update(task_id, percent_done)

      "Updated task #{task_id}, '#{task.name}' to #{percent_done}%"
    end
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

  def complete_task(task)
    @database.delete(task.id)

    "Task #{task.id} completed: \"#{task.name}\""
  end
end