class Application

  def initialize(database)
    @database = database
  end

  def list
    tasks = @database.list
    # TODO: Extract to renderer class
    if tasks.empty?
      "Nothing left to do!"
    else
      numbered_tasks = tasks.map.with_index { |t, i| "#{i + 1} #{t}" }
      numbered_tasks.join("\n")
    end
  end

  def add(task)
    @database.add(task)
    "Added '#{task}'"
  end

  # TODO: Validate task number as integer
  def complete(task_number_input)
    task_number = task_number_input.to_i

    task = @database.get(task_number)

    if task.nil?
      "No task with number #{task_number}"
    else
      @database.delete(task_number)
      "Task #{task_number} completed: \"#{task}\""
    end
  end
end