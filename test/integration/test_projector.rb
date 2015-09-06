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
    expected_pattern = "id\\s+name\\s+progress\\s+" +
      expected_tasks.map { |t| "#{t.id}\\s+#{t.name}\\s+#{t.percent_done}\%" }.join("\\s")

    assert_output(Regexp.new(expected_pattern)) do
      yield
    end
  end

  class TaskViewModel
    attr_reader :id
    attr_reader :name
    attr_reader :percent_done

    def initialize(id, name, percent_done)
      @id =  id
      @name = name
      @percent_done = percent_done
    end
  end
end