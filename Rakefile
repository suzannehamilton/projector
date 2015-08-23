require 'rake/testtask'

Rake::TestTask.new do |t|
  ENV["projector_db_environment"] = "test"
  t.pattern = "test/**/test_*.rb"
end