class DatabaseResolver
  def get_database
    db_environment = ENV["projector_db_environment"]

    if (db_environment == "test")
      Database.new("db/tasks_test.db")
    else
      Database.new("db/tasks.db")
    end
  end
end