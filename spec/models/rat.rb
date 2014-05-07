class Rat
  include MongoMapper::EmbeddedDocument
  attr_accessible :name, :cage

  key :name, String

  embedded_in :cage
end
