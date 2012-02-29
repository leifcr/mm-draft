# encoding: UTF-8
require File.expand_path('../lib/version', __FILE__)
Gem::Specification.new do |s|
  s.name               = 'mm-draft'
  s.homepage           = 'http://github.com/leifcr/mm-draft'
  
  s.summary            = 'Draft plugin for Mongo Mapper'
  s.authors            = ['Leif Ringstad']
  s.email              = ['leifcr@gmail.com']
  s.version            = MongoMapperDraft::Version
  s.platform           = Gem::Platform::RUBY
  s.files = Dir.glob("{lib,test}/**/*") + %w[LICENSE README.markdown]

  s.test_files = Dir.glob("{test}/**/*")

  s.require_path 		   = 'lib'

  s.add_dependency 'mongo_mapper', '~> 0.11.0'
  s.add_development_dependency 'shoulda', '~> 2.11.3'
  s.add_development_dependency 'mm-tree'
end