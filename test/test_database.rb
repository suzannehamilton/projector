require 'database'
require "minitest/autorun"

class TestDatabase < Minitest::Test
  def test_task_list_is_empty_by_default
    assert_empty(Database.new.list)
  end
end