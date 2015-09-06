require 'rake/testtask'

Rake::TestTask.new do |t|
  ENV["projector_db_environment"] = "test"
  t.pattern = "test/**/test_*.rb"
end

Rake::TestTask.new do |t|
  ENV["projector_db_environment"] = "test"
  t.name = "test:integration"
  t.pattern = "test/integration/**/test_*.rb"
end

Rake::TestTask.new do |t|
  ENV["projector_db_environment"] = "test"
  t.name = "test:unit"
  t.test_files = Dir['test/**/test_*.rb'].reject do |path|
    path.include?('integration')
  end
end