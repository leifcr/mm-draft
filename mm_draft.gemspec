# encoding: UTF-8
#require File.expand_path('../lib/mongo_mapper/plugins/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name               = 'mm_draft'
  s.homepage           = 'http://github.com/luuf/mm_draft'
  
  s.summary            = 'Draft plugin for Mongo Mapper'
  s.authors            = ['Leif Ringstad']
  s.email              = ['leifcr@gmail.com']
	s.version            = '0.1.0'
	#s.version            = MongoMapper::Plugins::Draft::VERSION
  s.platform           = Gem::Platform::RUBY
  # s.files              = Dir.glob("{lib,test}/**/*") + %w[LICENSE README.markdown]
  s.files = [ "Gemfile", 
              "History.txt",   
  					 	"LICENSE", 
  					 	"mm_draft.gemspec", 
  					 	"Rakefile", 
  					 	"README.markdown", 
  					 	"lib/mm_draft.rb", 
  					 	"lib/mongo_mapper/plugins/draft.rb", 
  					 	"mm_draft.gemspec"]

  s.require_paths 		 = ["lib"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongo_mapper>, [">= 0.8.6"])
      s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_development_dependency(%q<rake>, [">= 0.0.0"])
    else
      s.add_dependency(%q<mongo_mapper>, [">= 0.8.6"])
      s.add_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_dependency(%q<rake>, [">= 0.0.0"])
    end
  else
    s.add_dependency(%q<mongo_mapper>, [">= 0.8.6"])
    s.add_dependency(%q<rspec>, [">= 1.3.0"])
    s.add_dependency(%q<rake>, [">= 0.0.0"])
  end

#  s.add_dependency 'mongo_mapper',            '~> 0.8.6' # only tested with rails3 branch...

#  s.add_development_dependency 'rake'
#  s.add_development_dependency 'shoulda',           '~> 2.11'
#  s.add_development_dependency 'timecop',           '~> 0.3.1'
#  s.add_development_dependency 'mocha',             '~> 0.9.8'
end