require "thor"

class Projector < Thor
  desc "hello NAME", "say hello to NAME"
  def hello(name)
    puts "Hello #{name}"
  end
end

Projector.start(ARGV)