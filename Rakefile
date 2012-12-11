require "bundler/gem_tasks"
require 'rubygems'
require 'rake'

require File.join(File.dirname(__FILE__), 'lib', 'mongo_mapper', 'plugins', 'draft', 'version')

require 'rake/testtask'
namespace :test do
  Rake::TestTask.new(:units) do |test|
    test.libs << 'test'
    test.ruby_opts << '-rubygems'
    test.pattern = 'test/unit/**/test_*.rb'
    test.verbose = true 
  end

#TODO Add performance
  Rake::TestTask.new(:performance) do |test|
    test.libs << 'test'
    test.ruby_opts << '-rubygems'
    test.pattern = 'test/performance/test/**/*.rb'
    test.verbose = true 
  end
end

task :default => 'test:units'

