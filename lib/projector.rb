require "thor"
require "application"

class Projector < Thor

  def initialize(args = [], local_options = {}, config = {})
    super

    @application = Application.new
  end

  desc "list", "list unfinished tasks"
  def list
    puts "Nothing left to do!"
  end

  desc "add TASK", "add a new task named TASK"
  def add(name)
    puts "Added '#{name}'"
  end
end
