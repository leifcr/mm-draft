class MonkeyNoDraft
  include MongoMapper::Document
  attr_accessible :name, :age

  key :name, String
  key :age, Integer
end
