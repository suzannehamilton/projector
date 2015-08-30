require "thor"
require_relative "application"
require_relative "database"
require_relative "database_resolver"
require_relative "view/renderer"
require_relative "projector_list"

class Projector < Thor

  def initialize(args = [], local_options = {}, config = {})
    super

    database = DatabaseResolver.new.get_database
    renderer = Renderer.new

    @application = Application.new(database, renderer)
  end

  # register(class_name, subcommand_alias, usage_list_string, description_string)
  register(ProjectorList, "counter", "counter", "Prints some numbers in sequence")

  desc "list", "list unfinished tasks"
  def list
    # TODO: Add columns headers
    tasks = @application.list
    if tasks.empty?
      say "Nothing left to do!"
    else
      print_table tasks
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

  desc "update TASK_NUMBER", "set task labelled TASK_NUMBER as PERCENTAGE complete"
  def update(task_number, percentage)
    say @application.update(task_number, percentage)
  end
end
