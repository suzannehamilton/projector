require_relative "application"
require_relative "database/database_resolver"
require_relative "view/task_view_model"
require_relative "service/random_task_service"

# Helper which commonises building the dependency-injected Application object.
# This is a bit of a hack which is needed because Thor constructs the main Projector
# class and the related command classes, so the dependencies cannot be injected into
# those classes
class CliInitializer

  def self.build_application
    task_factory = TaskFactory.new
    random_task_service = RandomTaskService.new
    database = DatabaseResolver.new(task_factory).get_database
    task_view_model_factory = TaskViewModelFactory.new

    return Application.new(database, task_factory, random_task_service, task_view_model_factory)
  end
end