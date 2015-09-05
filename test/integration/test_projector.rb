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

  def test_can_update_done_percentage
    capture_io do
      Projector.new.invoke(:add, ["Comb the rabbit"])
    end

    assert_output("Updated task 1, 'Comb the rabbit' to 60%\n") do
      Projector.new.invoke(:update, ["1", "60"])
    end

    assert_task_list_output([Task.new(1, "Comb the rabbit", 60)]) do
      Projector.new.invoke(:list)
    end
  end

  def test_updating_rejects_invalid_task_id
    capture_io do
      Projector.new.invoke(:add, ["Comb the rabbit"])
    end

    assert_raises Thor::MalformattedArgumentError do
      Projector.new.invoke(:update, ["invalid_id", "60"])
    end
  end

  def test_updating_rejects_invalid_percent_done
    capture_io do
      Projector.new.invoke(:add, ["Comb the rabbit"])
    end

    assert_raises Thor::MalformattedArgumentError do
      Projector.new.invoke(:update, ["1", "not a percentage"])
    end
  end

  def assert_task_list_output(expected_tasks)
    expected_pattern = "id\\s+name\\s+progress\\s+" +
      expected_tasks.map { |t| "#{t.id}\\s+#{t.name}\\s+#{t.percent_done}\%" }.join("\\s")

    assert_output(Regexp.new(expected_pattern)) do
      yield
    end
  end
end