# encoding: UTF-8
require File.join(File.dirname(__FILE__), 'lib','mongo_mapper', 'plugins', 'draft', 'version')

Gem::Specification.new do |s|
  s.name                          = 'mm-draft'
  s.homepage                      = 'http://github.com/leifcr/mm-draft'
  s.summary                       = 'A MongoMapper extension adding draft/publishing support'

  s.require_paths                 = ['lib']
  s.authors                       = ['Leif Ringstad']
  s.email                         = ['leifcr@gmail.com']
  s.version                       = MongoMapper::Draft::VERSION
  s.platform                      = Gem::Platform::RUBY
  s.files                         = Dir.glob('lib/**/*') + %w[Gemfile Rakefile README.md]
  s.test_files                    = Dir.glob('test/**/*')

  s.add_dependency 'i18n'
  s.add_dependency 'mongo_mapper'
end
