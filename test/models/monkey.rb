require "mongo_mapper"
require "mm_draft"
# require "mongo_mapper_acts_as_tree"

class Monkey
  include MongoMapper::Document
  plugin MongoMapper::Plugins::Draft
  key :name, String
end


# require "mongo_mapper/plugins/draft"
# plugin MongoMapper::Plugins::Draft
