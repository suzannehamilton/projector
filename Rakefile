require 'rake/testtask'

# TODO: Run interation and unit tests separately
Rake::TestTask.new do |t|
  ENV["projector_db_environment"] = "test"
  t.pattern = "test/**/test_*.rb"
end