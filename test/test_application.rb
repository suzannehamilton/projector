require "minitest/autorun"
require "application"

class TestApplication < Minitest::Test

  def setup
    @database = MiniTest::Mock.new
    @application = Application.new(@database)
  end

  def test_listing_empty_task_list_identifies_that_no_tasks_are_available
    @database.expect(:list, [])
    assert_equal("Nothing left to do!", @application.list)
  end

  def test_adding_a_task_to_list_returns_task_name
    # TODO: Verify that mock is called
    assert_equal("Added 'Some task'", @application.add("Some task"))
  end
end