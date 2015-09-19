class Update < Thor::Group

  def initialize(args = [], local_options = {}, config = {})
    super

    @application = CliInitializer::build_application
  end

  argument :id, :type => :numeric
  argument :percent_done, :type => :numeric
  def update
    say @application.update(id, percent_done).render
  end
end