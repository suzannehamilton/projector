class Application

  def initialize(database)
    @database = database
  end

  def list
    tasks = @database.list
    if tasks.empty?
      "Nothing left to do!"
    else
      numbered_tasks = tasks.map { |t| "#{t.id} #{t.name}" }
      numbered_tasks.join("\n")
    end
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
        "Task #{task_number} completed: \"#{task}\""
      end
    else
      "Invalid task ID 'not_an_integer'"
    end
  end
end