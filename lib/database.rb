require "sqlite3"

class Database

  def initialize(db_file)
    # Open the database
    @db = SQLite3::Database.new db_file

    # Create the tasks table if it doesn't already exist
    rows = @db.execute <<-SQL
      create table if not exists task (
        name varchar
      );
    SQL
  end

  def list
    return @db.execute("select * from task").map { |r| r[0] }
  end

  def add(task)
    @db.execute("insert into task values ( ? )", task)
    # TODO: Handle tasks with the same name
  end
end