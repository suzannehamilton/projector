require "minitest/autorun"
require "projector"

class TestProjector < Minitest::Test

  TEST_DB_FILE = "db/tasks_test.db"

  def setup
    File::delete(TEST_DB_FILE) if File::exist?(TEST_DB_FILE)
  end

  Minitest::after_run do
    File::delete(TEST_DB_FILE)
  end

  def assert_task_list_output(expected_tasks)
    expected_pattern = "^id\\s+name\\s+progress\\s+" +
      expected_tasks.map { |t|
        size = t.size.nil? ? 100 : t.size

        "#{t.id}\\s+#{t.name}\\s+#{t.percent_done}\% complete" +
        (t.units.nil? ? "" : "\\s+\\(#{t.progress}\\/#{size} #{t.units}\\)")
      }.join("\\s+") + "$"

    assert_output(Regexp.new(expected_pattern)) do
      yield
    end
  end

  class TaskViewModel
    attr_reader :id
    attr_reader :name
    attr_reader :progress
    attr_reader :units
    attr_reader :size
    attr_reader :percent_done

    def initialize(id, name, progress, units = nil, size = nil, percent_done = progress)
      @id =  id
      @name = name
      @progress = progress
      @units = units
      @size = size
      @percent_done = percent_done
    end
  end
end