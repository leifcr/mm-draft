require 'rubygems'
require 'bundler/setup'

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
elsif ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'mm-draft'

Bundler.require(:default, :test)

MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)
MongoMapper.database = "mm-draft-test"

Dir["#{File.dirname(__FILE__)}/models/*.rb"].each {|file| require file}

DatabaseCleaner.strategy = :truncation

class Test::Unit::TestCase
  # Drop all collections after each test case.
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  # Make sure that each test case has a teardown
  # method to clear the db after each test.
  def inherited(base)
    base.define_method setup do
      super
    end

    base.define_method teardown do
      super
    end
  end

end
