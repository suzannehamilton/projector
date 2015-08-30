# TODO: If this works, move to a separate command directory
class ProjectorList < Thor::Group
  desc "Prints 1 2 3"

    def one
      puts 1
    end

    def two
      puts 2
    end

    def three
      puts 3
    end
end