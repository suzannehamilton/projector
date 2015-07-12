require 'database_resolver'
require "minitest/autorun"

class TestDatabaseResolver < Minitest::Test

  TEST_DB_FILE = "db/tasks.db"

  def setup
    File::delete(TEST_DB_FILE) if File::exist?(TEST_DB_FILE)
  end

  # TODO: Determine how to get after_tests to run, since it looks like they aren't being hit
  def after_tests
    File::delete(TEST_DB_FILE)
  end

  def test_returns_empty_database
    assert_empty(DatabaseResolver.new.get_database.list)
  end

  def test_creates_database_file
    refute(File::file?(TEST_DB_FILE), "Test setup is incorrect: a DB file exists at #{TEST_DB_FILE} but none was expected")
    DatabaseResolver.new.get_database.list
    assert(File::file?(TEST_DB_FILE))
  end

  # TODO: Test that an existing DB file is picked up correctly
  # TODO: Test that running 'list' without the test env variable does not fail
end