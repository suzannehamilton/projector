require "thor"
require_relative "application"
require_relative "database"
require_relative "database_resolver"

class Projector < Thor

  def initialize(args = [], local_options = {}, config = {})
    super

    database = DatabaseResolver.new.get_database
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

  desc "complete TASK_NUMBER", "mark task labelled TASK_NUMBER as complete"
  def complete(task_number)
    puts @application.complete(task_number)
  end
end
