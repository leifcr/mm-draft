require 'rubygems'
require 'rake'

require File.join(File.dirname(__FILE__), 'lib', 'version')

require 'rake/testtask'
namespace :test do
  Rake::TestTask.new(:unit) do |test|
    test.libs << 'test'
    test.ruby_opts << '-rubygems'
    test.pattern = 'test/unit/**/test_*.rb'
    test.verbose = true
  end
end

task :default => 'test:unit'

desc 'Builds the gem'
task :build do
  sh 'gem build mm-draft.gemspec'
  Dir.mkdir('pkg') unless File.directory?('pkg')
  sh "mv mm-versioned-#{MongoMapper::Versioned::VERSION}.gem pkg/mm-draft-#{MongoMapper::Versioned::VERSION}.gem"
end

#desc 'Generate documentation for the mm_drafts plugin.'
#Rake::RDocTask.new(:rdoc) do |rdoc|
#  rdoc.rdoc_dir = 'rdoc'
#  rdoc.title    = 'Mongomapper Draft'
#  rdoc.options << '--line-numbers' << '--inline-source'
#  rdoc.rdoc_files.include('README.markdown')
#  rdoc.rdoc_files.include('lib/**/*.rb')
#end