require 'rubygems'
require 'bundler/setup'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'draft'

Bundler.require(:default, :test)

MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)
MongoMapper.database = "mm-draft-performance"

Dir["#{File.dirname(__FILE__)}/models/*.rb"].each {|file| require file}

DatabaseCleaner.strategy = :truncation
