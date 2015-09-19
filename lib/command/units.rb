class Units < Thor::Group

  def initialize(args = [], local_options = {}, config = {})
    super

    @application = CliInitializer::build_application
  end

  argument :id, :type => :numeric
  argument :units_name, :type => :string, :required => false
  def units
    say @application.units(id, units_name).render
  end
end