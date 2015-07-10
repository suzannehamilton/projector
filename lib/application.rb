class Application

  def initialize(database)
    @database = database
  end

  def list
    tasks = @database.list
    if tasks.empty?
      "Nothing left to do!"
    else
      tasks[0]
    end
  end

  def add(task)
    @database.add(task)
    "Added '#{task}'"
  end
end