require "thor"
require_relative "cli_initializer"
require_relative "command/list"
require_relative "command/add"
require_relative "command/complete"

class Projector < Thor

  def initialize(args = [], local_options = {}, config = {})
    super

    @application = CliInitializer::build_application
  end

  register(List, "list", "list", "List unfinished tasks")
  register(Add, "add", "add TASK", "Add a new task named TASK")
  register(Complete, "complete", "complete TASK_ID", "Mark task labelled TASK_ID as complete")

  desc "update TASK_NUMBER", "Set task labelled TASK_NUMBER as PERCENTAGE complete"
  def update(task_number, percentage)
    say @application.update(task_number, percentage)
  end
end
