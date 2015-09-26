require_relative "database"

class DatabaseResolver

  def initialize(task_factory)
    @task_factory = task_factory
  end

  def get_database
    db_environment = ENV["projector_db_environment"]

    if (db_environment == "test")
      Database.new("db/tasks_test.db", @task_factory)
    else
      Database.new("db/tasks.db", @task_factory)
    end
  end
end