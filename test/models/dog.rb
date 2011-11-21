require "mongo_mapper"
require "mm_draft"
class Dog
  include MongoMapper::Document
  plugin MongoMapper::Plugins::Draft
  key :name, String
end
