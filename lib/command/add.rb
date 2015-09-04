class Add < Thor::Group

  def initialize(args = [], local_options = {}, config = {})
    super

    @application = CliInitializer::build_application
  end

  argument :name, :type => :string
  def add
    say @application.add(name)
  end
end