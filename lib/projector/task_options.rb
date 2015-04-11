module Projector
  class TaskOptions
    attr_reader :task

    def initialize(argv)
      parser = OptionParser.new

      parser.on("-aTASK", "--add TASK", "A new task") do |task|
        @task = task
      end

      parser.parse(argv)
    end
  end
end