require 'database_resolver'
require "minitest/autorun"

class TestDatabaseResolver < Minitest::Test

  def test_returns_empty_database
    assert_empty(DatabaseResolver.new.get_database.list)
  end
end