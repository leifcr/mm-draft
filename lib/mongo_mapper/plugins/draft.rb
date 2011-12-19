#$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'mongo_mapper'

module MongoMapper
  module Plugins
    module Draft
      extend ActiveSupport::Concern

      included do
        #puts "Configuring #{model}..."
        key :draft, Boolean, :default => true
        key :draft_record_published_id, ObjectId # points to the live page version if draft == true. else NIL
        # Before destroy callback to remove published record
        before_destroy :unpublish
      end

      # module ClassMethods
      # end
    
      # InstanceMethods module will automatically get included
      module InstanceMethods

        def draft?
          self.draft
        end
        
        def published?
          if draft?
            return false if self.draft_record_published_id == nil # save a query and return false
            return true if (self.class.find(self.draft_record_published_id) != nil)
          else
            return true
          end
          false
        end
        
        def publish
          if (draft? == false) # don't publish non-drafts... 
            return false
          end
          
          if (self.changed?) # save any changes, in case publish is called directly instead of save
              return false if (self.save == false)
          end
          # if already published, clone onto existing record..
          if (self.published?)
            live_record = self.clone
            live_record._id = self.published_record_id
          else
            live_record = self.clone
          end
          
          self.draft_record_published_id = live_record._id
          self.save!
          
          live_record.draft = false;
          live_record.save!
          return true
        end
        
        def published_record
          if draft?
            return nil if self.draft_record_published_id == nil # save a query and return nil of draft_record_published_id == nil
            self.class.find(self.draft_record_published_id)
          else
            self
          end
        end

        def published_record_id
          if draft?
            self.draft_record_published_id
          else
            self._id
          end
        end
        
        def draft_record
          if draft?
            self
          else
            self.class.all(:conditions => { :draft => true, :draft_record_published_id => self._id }).first
        end
        end
        
        def unpublish
          published_rec = self.published_record
          draft_rec = self.draft_record
  
          self.class.skip_callback(:destroy, :before, :unpublish)
          published_rec.destroy if published_rec != nil # destroy published record
          self.class.set_callback(:destroy, :before, :unpublish)

          draft_rec.draft_record_published_id = nil if draft_rec != nil # update draft record
          draft_rec.save! if draft_rec != nil
          # if draft?
          #   published = self.class.find(self.draft_record_published_id)
          #   published.destroy if (published != nil)
          #   self.draft_record_published_id = nil
          #   self.save! # remove draft_record_published_id
          # else
          #   self.draft_record.unpublish
          # end
        end
        
      end # InstanceMethods
    end
  end
end
