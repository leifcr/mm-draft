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

desc 'Builds the gem'
task :build do
  sh 'gem build mm-draft.gemspec'
  Dir.mkdir('pkg') unless File.directory?('pkg')
  sh "mv mm-draft-#{MongoMapper::Draft::VERSION}.gem pkg/mm-draft-#{MongoMapper::Draft::VERSION}.gem"
end

desc 'Builds and Installs the gem'
task :install => :build do
  sh "gem install pkg/mm-draft-#{MongoMapper::Draft::VERSION}.gem"
end
