#require 'bundler'
#Bundler::GemHelper.install_tasks

require 'rake'

desc 'Default: run unit tests.'
task :default => :test

require 'rake/testtask'

desc 'Test the mm_drafts plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = t
end

#desc 'Generate documentation for the mm_drafts plugin.'
#Rake::RDocTask.new(:rdoc) do |rdoc|
#  rdoc.rdoc_dir = 'rdoc'
#  rdoc.title    = 'Mongomapper Draft'
#  rdoc.options << '--line-numbers' << '--inline-source'
#  rdoc.rdoc_files.include('README.markdown')
#  rdoc.rdoc_files.include('lib/**/*.rb')
#end