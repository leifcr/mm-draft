require 'rubygems'
require 'bundler/setup'
require 'test/unit'
require 'shoulda'

Bundler.require(:development)

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'mm-draft'


MongoMapper.database = "mm-draft_test"

Dir["#{File.dirname(__FILE__)}/models/*.rb"].each {|file| require file}

class Test::Unit::TestCase
  # Drop all collections after each test case.
  def teardown
    MongoMapper.database.collections.each {|collection| collection.drop unless collection.name =~ /(.*\.)?system\..*/  }
  end

  # Make sure that each test case has a teardown
  # method to clear the db after each test.
  def inherited(base)
    base.define_method teardown do 
      super
    end
  end
  
end
