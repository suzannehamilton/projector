class List < Thor::Group

  def initialize(args = [], local_options = {}, config = {})
    super

    @application = CliInitializer::build_application
  end

  def list
    # TODO: Add columns headers
    tasks = @application.list
    if tasks.empty?
      say "Nothing left to do!"
    else
      print_table tasks
    end
  end
end