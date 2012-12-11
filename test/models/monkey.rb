class Monkey
  include MongoMapper::Document
  plugin MongoMapper::Plugins::Draft

  attr_accessible :name
  
  key :name, String

  timestamps!
end
