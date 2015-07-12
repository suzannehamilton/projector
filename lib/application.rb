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
      tasks.join("\n")
    end
  end

  def add(task)
    @database.add(task)
    "Added '#{task}'"
  end
end