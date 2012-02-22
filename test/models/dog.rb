require 'mm-tree'

class Dog
  include MongoMapper::Document
  plugin MongoMapper::Plugins::Draft
  plugin MongoMapper::Plugins::Tree
  key :name, String
end
