class Add < Thor::Group

  def initialize(args = [], local_options = {}, config = {})
    super

    @application = CliInitializer::build_application
  end

  argument :name, :type => :string
  class_option :units, :type => :string, :required => false, :aliases => "-u"
  class_option :size, :type => :numeric, :required => false, :aliases => "-s"
  def add
    say @application.add(name, options[:units], options[:size]).render
  end
end