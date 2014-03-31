class Dog
  include MongoMapper::Document
  plugin MongoMapper::Plugins::Draft

  attr_accessible :name

  key :name, String
  key :published_at, Time

  timestamps!
end
