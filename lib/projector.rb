require "thor"
require_relative "cli_initializer"
require_relative "command/list"
require_relative "command/add"
require_relative "command/complete"
require_relative "command/update"
require_relative "command/units"
require_relative "command/size"
require_relative "command/random_task"

class Projector < Thor

  def initialize(args = [], local_options = {}, config = {})
    super

    @application = CliInitializer::build_application
  end

  register(List, "list", "list", "List unfinished tasks")
  register(Add, "add", "add TASK [-u UNITS]", "Add a new task named TASK with progress marked in UNITS")
  register(Complete, "complete", "complete TASK_ID", "Mark task labelled TASK_ID as complete")
  register(Update, "update", "update TASK_ID PROGRESS", "Udate progress of task labelled TASK_ID to PROGRESS")
  register(Units, "units", "units TASK_ID UNITS", "Update task labelled TASK_ID to use units UNITS")
  register(Size, "size", "size TASK_ID SIZE", "Update task labelled TASK_ID to size SIZE")
  register(RandomTask, "random", "random", "Get a random task to work on")
end
