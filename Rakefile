require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'Start an irb session with the gem loaded'
task :irb do
  sh 'irb -I ./lib -r weka'
end
