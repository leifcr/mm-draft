# encoding: UTF-8
require File.join(File.dirname(__FILE__), 'lib', 'version')

Gem::Specification.new do |s|
  s.name                          = 'mm-draft'
  s.homepage                      = 'http://github.com/leifcr/mm-draft'
  s.summary                       = 'Draft plugin for Mongo Mapper'
#  s.description                   = 'Draft plugin for Mongo Mapper'
  s.require_paths                 = ['lib']
  s.authors                       = ['Leif Ringstad']
  s.email                         = ['leifcr@gmail.com']
  s.version                       = MongoMapper::Plugins::Draft::Version
  s.platform                      = Gem::Platform::RUBY
  s.files                         = Dir.glob('lib/**/*') + %w[LICENSE README.markdown]
  s.test_files                    = Dir.glob('test/**/*')

  s.add_dependency 'i18n'
  s.add_dependency 'mongo_mapper', '~> 0.12.0'
  # s.add_development_dependency 'mm-tree'
end
