class Application

  def initialize(database, renderer)
    @database = database
    @renderer = renderer
  end

  def list
    tasks = @database.list

    tasks.map { |t| @renderer.render(t) }
  end

  def add(task_name, units = nil)
    task = @database.add(task_name, units)
    "Added task #{task.id}: '#{task.name}', 0% complete" + (units.nil? ? "" : " (0/100 #{units})")
  end

  def complete(task_id)
    task = get_task(task_id)

    complete_task(task)
  end

  def update(task_id, progress)
    validate_progress(progress)

    task = get_task(task_id)

    if (progress == 100)
      complete_task(task)
    else
      updated_task = Task.new(task.id, task.name, progress, task.units)
      @database.save(updated_task)

      "Updated task #{task_id}, '#{task.name}' to #{progress}%"
    end
  end

  def units(task_id, new_units)
    task = get_task(task_id)

    updated_task = Task.new(task.id, task.name, task.progress, new_units)
    @database.save(updated_task)

    "Updated units of task #{task_id}, '#{task.name}' to '#{new_units}'. 0% complete (0/100 #{new_units})"
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

  def validate_progress(progress)
    # TODO: Handle progress which is not measured in percent
    if progress < 0 || progress > 100
      raise Thor::MalformattedArgumentError.new(
        "Cannot update task. Expected progress between 0 and 100, but got '#{progress}'")
    end
  end

  def complete_task(task)
    @database.delete(task.id)

    "Task #{task.id} completed: \"#{task.name}\""
  end
end