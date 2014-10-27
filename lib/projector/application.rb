require_relative "task_options"

module Projector
  class Application
    def initialize(argv)
      @params = TaskOptions.new(argv)
    end

    def run
      require "sqlite3"

        # Open a database
        db = SQLite3::Database.new "db/tasks.db"

        # Create a database
        rows = db.execute <<-SQL
          create table if not exists tasks (
            name varchar,
            completion smallint
          );
        SQL

        # Insert a new task
        {
          @params.task => 0
        }.each do |pair|
          db.execute "insert into tasks values ( ?, ? )", pair
        end

        # Execute inserts with parameter markers
        # db.execute("INSERT INTO students (name, email, grade, blog)
        #             VALUES (?, ?, ?, ?)", [@name, @email, @grade, @blog])

        # Find a few rows
        db.execute( "select * from tasks" ) do |row|
          p row
        end
    end
  end
end
