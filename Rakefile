require "bundler/gem_tasks"
require 'rspec/core/rake_task'

require File.join(File.dirname(__FILE__), 'lib', 'mongo_mapper', 'plugins', 'draft', 'version')

require 'rake/testtask'
namespace :test do
  Rake::TestTask.new(:performance) do |test|
    test.libs << 'test'
    test.ruby_opts << '-rubygems'
    test.pattern = 'test/performance/test/**/*.rb'
    test.verbose = true
  end
end

RSpec::Core::RakeTask.new(:spec)
task :default => :spec
gemspec = eval(File.read("mm-draft.gemspec"))
