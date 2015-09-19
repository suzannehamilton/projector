class Complete < Thor::Group

  def initialize(args = [], local_options = {}, config = {})
    super

    @application = CliInitializer::build_application
  end

  argument :id, :type => :numeric
  def complete
    say @application.complete(id).render
  end
end