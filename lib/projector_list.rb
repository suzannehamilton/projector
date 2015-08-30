# TODO: If this works, move to a separate command directory
class ProjectorList < Thor::Group

  # TODO: Commonise with main Projector class. Use a module?
  def initialize(args = [], local_options = {}, config = {})
    super

    database = DatabaseResolver.new.get_database
    renderer = Renderer.new

    @application = Application.new(database, renderer)
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