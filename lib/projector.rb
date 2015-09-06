require "thor"
require_relative "cli_initializer"
require_relative "command/list"
require_relative "command/add"
require_relative "command/complete"
require_relative "command/update"
require_relative "command/units"

class Projector < Thor

  def initialize(args = [], local_options = {}, config = {})
    super

    @application = CliInitializer::build_application
  end

  register(List, "list", "list", "List unfinished tasks")
  # TODO: Document units option
  register(Add, "add", "add TASK", "Add a new task named TASK")
  register(Complete, "complete", "complete TASK_ID", "Mark task labelled TASK_ID as complete")
  # TODO: Switch from "percent done" to "progress" in docs and variable names
  register(Update, "update", "update TASK_ID PERCENT_DONE", "Set task labelled TASK_ID as PRGR complete")
  register(Units, "units", "units TASK_ID UNITS", "Update task labelled TASK_ID to use units UNITS")
end
