module Projector
  class Application
    def initialize(argv)
      @params = parse_options(argv)
    end

    def run
      require "sqlite3"

        # Open a database
        db = SQLite3::Database.new "test.db"

        # Create a database
        rows = db.execute <<-SQL
          create table numbers (
            name varchar(30),
            val int
          );
        SQL

        # Execute a few inserts
        {
          "one" => 1,
          "two" => 2,
        }.each do |pair|
          db.execute "insert into numbers values ( ?, ? )", pair
        end

        # Execute inserts with parameter markers
        # db.execute("INSERT INTO students (name, email, grade, blog)
        #             VALUES (?, ?, ?, ?)", [@name, @email, @grade, @blog])

        # Find a few rows
        db.execute( "select * from numbers" ) do |row|
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
