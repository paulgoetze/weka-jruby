require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :prepare
task install: :prepare

desc 'Install weka jars & dependencies'
task :prepare do
  require 'lock_jar'
  lib_path = File.expand_path('.', File.dirname(__FILE__))
  jars_dir = File.join(lib_path, 'jars')

  LockJar.install('Jarfile.lock', local_repo: jars_dir)
end

desc 'Start an irb session with the gem loaded'
task :irb do
  sh 'irb -I ./lib -r weka'
end
