class RandomTask < Thor::Group

  def initialize(args = [], local_options = {}, config = {})
    super

    @application = CliInitializer::build_application
  end

  def random
    say @application.random.render
  end
end