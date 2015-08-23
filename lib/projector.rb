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
    # TODO: Add columns headers
    if @application.list.empty?
      say "Nothing left to do!"
    else
      print_table @application.list
    end
  end

  desc "add TASK", "add a new task named TASK"
  def add(name)
    say @application.add(name)
  end

  desc "complete TASK_NUMBER", "mark task labelled TASK_NUMBER as complete"
  def complete(task_number)
    say @application.complete(task_number)
  end
end
