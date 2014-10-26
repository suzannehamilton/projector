module Projector
  class Application
    def initialize(argv)
      puts "Hello world!"
      @params, @files = parse_options(argv)
    end

    def run
      puts "Running now!"
    end

    def parse_options(argv)
      params = {}
      parser = OptionParser.new

      parser.on("-n") { params[:line_numbering_style] ||= :all_lines         }
      parser.on("-b") { params[:line_numbering_style]   = :significant_lines }
      parser.on("-s") { params[:squeeze_extra_newlines] = true               }
      parser.on("-f", "--full-foo FOO", "Some value of 'foo'") do |foo|
        params[:foo_param] = foo
      end

      files = parser.parse(argv)

      puts params
      puts files

      [params, files]
    end
  end
end
