require "thor"
require "application"
require "database"

class Projector < Thor

  def initialize(args = [], local_options = {}, config = {})
    super

    database = Database.new
    @application = Application.new(database)
  end

  desc "list", "list unfinished tasks"
  def list
    puts @application.list
  end

  desc "add TASK", "add a new task named TASK"
  def add(name)
    puts @application.add(name)
  end
end
