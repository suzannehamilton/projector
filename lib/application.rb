class Application

  def initialize(database)
    @database = database
  end

  def list
    if @database.list.empty?
      "Nothing left to do!"
    end
  end

  def add(task)
    @database.add(task)
    "Added '#{task}'"
  end
end