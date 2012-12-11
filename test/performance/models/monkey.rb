class Monkey
  include MongoMapper::Document
  plugin MongoMapper::Plugins::Draft

  attr_accessible :name, :age

  key :name, String
  key :age, Integer
end
