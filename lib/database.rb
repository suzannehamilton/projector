require "sqlite3"
require_relative "model/task"

class Database

  def initialize(db_file)
    # Open the database
    @db = SQLite3::Database.new db_file

    # Create the tasks table if it doesn't already exist
    rows = @db.execute <<-SQL
      create table if not exists task (
        name VARCHAR,
        percent_done INT
      );
    SQL
  end

  def list
    return @db.execute("select rowid, name, percent_done from task").map { |r| Task.new(r[0], r[1], r[2]) }
  end

  def add(task)
    @db.execute("insert into task values ( ?, ? )", task, 0)
  end

  def get(task_id)
    tasks = @db.execute("select name, percent_done from task where rowid = ( ? )", task_id)
    task = tasks[0]
    tasks.empty? ? nil : Task.new(task_id, task[0], task[1])
  end

  def update(task_id, percent_done)
    @db.execute("update task set percent_done = ( ? ) where rowid = ( ? )", percent_done, task_id)
  end

  def delete(task_id)
    @db.execute("delete from task where rowid = ( ? )", task_id)
  end
end