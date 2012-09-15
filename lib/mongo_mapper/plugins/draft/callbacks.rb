module MongoMapper
  module Plugins
    module Draft
      module Callbacks
        extend ActiveSupport::Concern        
        included do
          before_destroy :unpublish        
        end # included_do
      end
    end # Versioned
  end # Module plugins
end # module MongoMapper