require_relative "application"
require_relative "database_resolver"
require_relative "view/renderer"
require_relative "view/task_view_model_factory"

# Helper which commonises building the dependency-injected Application object.
# This is a bit of a hack which is needed because Thor constructs the main Projector
# class and the related command classes, so the dependencies cannot be injected into
# those classes
class CliInitializer

  def self.build_application
    database = DatabaseResolver.new.get_database
    renderer = Renderer.new
    task_view_model_factory = TaskViewModelFactory.new

    return Application.new(database, renderer, task_view_model_factory)
  end
end