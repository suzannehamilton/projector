class Size < Thor::Group

  def initialize(args = [], local_options = {}, config = {})
    super

    @application = CliInitializer::build_application
  end

  argument :id, :type => :numeric
  argument :new_size, :type => :numeric, :required => true
  def size
    say @application.size(id, new_size).render
  end
end