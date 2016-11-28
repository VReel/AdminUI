# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
rescue LoadError
end

Rails.application.load_tasks
task ci: %i(rubocop spec)
