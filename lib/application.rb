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

  def complete(task_number_input)
    task_number = Integer(task_number_input) rescue nil

    if task_number

      task = @database.get(task_number)

      if task.nil?
        "No task with number #{task_number}"
      else
        @database.delete(task_number)
        "Task #{task_number} completed: \"#{task.name}\""
      end
    else
      "Invalid task ID 'not_an_integer'"
    end
  end

  # TODO: Commonise input validation. Can this be done by Thor itself?
  def update(task_number_input, percent_complete_input)
    task_id = task_number_input.to_i
    task = @database.get(task_id)

    percent_done = percent_complete_input.to_i
    @database.update(task_id, percent_done)

    "#{task_id} #{task.name} #{percent_complete_input}%"
  end
end