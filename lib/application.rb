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

  def complete(task_number)
    "No task with number #{task_number}"
  end
end