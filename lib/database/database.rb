require "sqlite3"
require_relative "../model/task"

class Database

  def initialize(db_file)
    # Open the database
    @db = SQLite3::Database.new db_file

    # Create the tasks table if it doesn't already exist
    rows = @db.execute <<-SQL
      create table if not exists task (
        name VARCHAR,
        progress INT,
        units VARCHAR,
        size INT
      );
    SQL
  end

  def list
    @db.execute("select rowid, name, progress, units, size from task")
      .map { |r| Task.new(r[0], r[1], r[2], r[3], r[4]) }
  end

  def add(task)
    task.id.nil? or raise ArgumentError.new("Cannot create new task. Task already has an id: '#{task.id}'")

    @db.execute("insert into task values ( ?, ?, ?, ? )", task.name, 0, task.units, task.size)
    new_task_id = @db.last_insert_row_id()
    get(new_task_id)
  end

  def get(task_id)
    tasks = @db.execute("select name, progress, units, size from task where rowid = ( ? )", task_id)
    task = tasks[0]
    tasks.empty? ? nil : Task.new(task_id, task[0], task[1], task[2], task[3])
  end

  # Update an existing task
  def save(task)
    if (task.id.nil?)
      raise ArgumentError.new("Cannot update task with id 'nil'")
    end

    @db.execute(
      "update task set name = ?, progress = ?, units = ?, size = ? where rowid = ?",
      task.name,
      task.progress,
      task.units,
      task.size,
      task.id)
  end

  def delete(task_id)
    @db.execute("delete from task where rowid = ( ? )", task_id)
  end
end