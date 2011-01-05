require "mongo_mapper"
require "mongo_mapper_acts_as_tree"
#require "mongo_mapper/plugins/acts_as_tree"
#  plugin MongoMapper::Plugins::ActsAsTree

class Dog
  include MongoMapper::Document
  include MongoMapper::Acts::Tree
  plugin MongoMapper::Plugins::Draft
  key :name, String

  key :order, Integer
  acts_as_tree :order => "order asc"
end
