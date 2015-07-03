require "thor"

class Projector < Thor

  desc "list", "list unfinihsed tasks"
  def list
    puts "Nothing left to do!"
  end

  desc "add TASK", "add a new task named TASK"
  def add(name)
    puts "Added '#{name}'"
  end
end
