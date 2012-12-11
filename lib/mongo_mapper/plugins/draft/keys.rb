module MongoMapper
  module Plugins
    module Draft
      module Keys
        extend ActiveSupport::Concern        
        included do
          key :draft, Boolean, :default => true
          key :draft_record_published_id, ObjectId # points to the live page version if draft == true. else NIL          
        end # included_do
      end # Keys
    end # Versioned
  end # Module plugins
end # module MongoMapper
