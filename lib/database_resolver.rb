class DatabaseResolver
  def get_database
    Database.new("db/tasks.db")
  end
end