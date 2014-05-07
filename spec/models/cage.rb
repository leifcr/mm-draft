class Cage
  include MongoMapper::Document
  plugin MongoMapper::Plugins::Draft
  attr_accessible :name, :rats, :horse
  attr_accessible :tags, :number, :sometime, :pi, :a_hash

  many :rats
  one  :horse

  key :tags,     Array
  key :number,   Integer
  key :name,     String
  key :sometime, Time
  key :pi,       Float
  key :a_hash,     Hash

  key :published_at, Time

  timestamps!
end
