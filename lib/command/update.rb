class Update < Thor::Group

  def initialize(args = [], local_options = {}, config = {})
    super

    @application = CliInitializer::build_application
  end

  argument :id, :type => :numeric
  argument :progress, :type => :numeric
  def update
    say @application.update(id, progress).render
  end
end