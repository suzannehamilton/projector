class Add < Thor::Group

  def initialize(args = [], local_options = {}, config = {})
    super

    @application = CliInitializer::build_application
  end

  argument :name, :type => :string
  class_option :units, :type => :string, :required => false, :aliases => "-u"
  def add
    say @application.add(name, options[:units])
  end
end