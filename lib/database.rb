require "sqlite3"
require_relative "model/task"

class Database

  def initialize(db_file)
    # Open the database
    @db = SQLite3::Database.new db_file

    # Create the tasks table if it doesn't already exist
    rows = @db.execute <<-SQL
      create table if not exists task (
        name VARCHAR
      );
    SQL
  end

  def list
    return @db.execute("select rowid, name from task").map { |r| Task.new(r[0], r[1]) }
  end

  def add(task)
    @db.execute("insert into task values ( ? )", task)
  end

  def get(task_id)
    tasks = @db.execute("select name from task where rowid = ( ? )", task_id)
    tasks.empty? ? nil : tasks[0][0]
  end

  def delete(task_id)
    @db.execute("delete from task where rowid = ( ? )", task_id)
  end
end