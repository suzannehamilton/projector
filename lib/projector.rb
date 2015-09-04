require "thor"
require_relative "cli_initializer"
require_relative "command/list"

class Projector < Thor

  def initialize(args = [], local_options = {}, config = {})
    super

    @application = CliInitializer::build_application
  end

  register(List, "list", "list", "List unfinished tasks")

  desc "add TASK", "Add a new task named TASK"
  def add(name)
    say @application.add(name)
  end

  desc "complete TASK_NUMBER", "Mark task labelled TASK_NUMBER as complete"
  def complete(task_number)
    say @application.complete(task_number)
  end

  desc "update TASK_NUMBER", "Set task labelled TASK_NUMBER as PERCENTAGE complete"
  def update(task_number, percentage)
    say @application.update(task_number, percentage)
  end
end
