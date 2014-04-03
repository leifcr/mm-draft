$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'rspec'

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
elsif ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

require 'mm-draft'
require 'database_cleaner'

require 'timecop'

Dir["#{File.dirname(__FILE__)}/models/*.rb"].each {|file| require file}

# MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)
MongoMapper.database = 'mm-draft-spec'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
  end
  config.after(:suite) do
    DatabaseCleaner.clean
    MongoMapper.database.command({dropDatabase: 1})
    # Mongoid.master.command({dropDatabase: 1})
  end
end
