module Projector
  class Application
    def initialize(argv)
      @params = parse_options(argv)
    end

    def run
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
