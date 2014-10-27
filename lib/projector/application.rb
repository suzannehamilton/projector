module Projector
  class Application
    def initialize(argv)
      @params = parse_options(argv)
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

        # Execute a few inserts
        {
          "Water the sheep" => 0,
          "Sheep collection day" => 10,
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

    def parse_options(argv)
      params = {}
      parser = OptionParser.new

      parser.on("-a", "--add TASK", "A new task") do |task|
        params[:task] = task
      end

      parser.parse(argv)

      params
    end
  end
end
