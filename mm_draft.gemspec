# encoding: UTF-8
require File.expand_path('./lib/mongo_mapper/plugins/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name               = 'mm_draft'
  s.homepage           = 'http://github.com/luuf/mm_draft'
  s.summary            = 'Draft pluing for Mongo Mapper'
  s.authors            = ['Leif Ringstad']
  s.email              = ['leifcr@gmail.com']
  s.version            = MongoMapper::Version
  s.platform           = Gem::Platform::RUBY
  s.files              = Dir.glob("{lib,test}/**/*") + %w[LICENSE README.markdown init.rb Rakefile]

  s.add_dependency 'mongo_mapper',            '~> 0.8.6' # only tested with rails3 branch...

  s.add_development_dependency 'rake'
#  s.add_development_dependency 'shoulda',           '~> 2.11'
#  s.add_development_dependency 'timecop',           '~> 0.3.1'
#  s.add_development_dependency 'mocha',             '~> 0.9.8'
end