class List < Thor::Group

  def initialize(args = [], local_options = {}, config = {})
    super

    @application = CliInitializer::build_application
  end

  def list
    tasks = @application.list
    if tasks.empty?
      say "Nothing left to do!"
    else
      print_table [["id", "name", "progress"]].concat(tasks)
    end
  end
end