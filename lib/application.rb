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

  def update(task_id, percent_complete_input)
    task = @database.get(task_id)

    percent_done = percent_complete_input.to_i
    @database.update(task_id, percent_done)

    "#{task_id} #{task.name} #{percent_complete_input}%"
  end
end