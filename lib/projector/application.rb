require "sqlite3"

require_relative "task_options"

module Projector
  class Application
    def initialize(argv)
      @params = TaskOptions.new(argv)

      initialize_db()
    end

    def run
        # Insert a new task
        {
          @params.task => 0
        }.each do |pair|
          @db.execute "insert into tasks values ( ?, ? )", pair
        end

        # Find a few rows
        @db.execute( "select * from tasks" ) do |row|
          p row
        end
    end

    private
    def initialize_db
        # Open the database
        @db = SQLite3::Database.new "db/tasks.db"

        # Create the tasks table if it doesn't already exist
        rows = @db.execute <<-SQL
          create table if not exists tasks (
            name varchar,
            completion smallint
          );
        SQL
    end
  end
end
