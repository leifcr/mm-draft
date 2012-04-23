class Monkey
  include MongoMapper::Document
  plugin MongoMapper::Plugins::Draft
  key :name, String
  timestamps!
end

