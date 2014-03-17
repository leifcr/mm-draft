require File.join(File.dirname(__FILE__), 'callbacks')
require File.join(File.dirname(__FILE__), 'keys')
# I18n.load_path << File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'locale', 'en.yml'), __FILE__)

module MongoMapper
  module Plugins
    module Draft

      extend ActiveSupport::Concern

      include MongoMapper::Plugins::Draft::Callbacks
      include MongoMapper::Plugins::Draft::Keys

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

        
        # if already published, keep some old data to update instead of insert
        if (self.published?)
          old_published_record = self.published_record
          # support for mm-tree
          # remove parents from previous published record
          if (self.respond_to?("parent_id_field") && self.respond_to?("path_field") && self.respond_to?("depth_field"))
            old_published_record.parent = nil
            old_published_record.save
          end
          # destroy old published record... Not ideal, but should work
          self.published_record.destroy! if self.published_record != nil
          live_record = self.clone
          live_record.created_at = old_published_record.created_at if self.respond_to?("created_at")
        else
          live_record = self.clone
          live_record.created_at = Time.now.utc if self.respond_to?("created_at")
        end

        self.draft_record_published_id = live_record._id
        self.class.skip_callback(:save, :before, :update_timestamps ) if self.respond_to?("updated_at")
        self.save!
        self.class.set_callback(:save, :before, :update_timestamps ) if self.respond_to?("updated_at")

        if (self.respond_to?("parent_id_field") && self.respond_to?("path_field") && self.respond_to?("depth_field"))
          # if so, remove the current parent (should have already been don)
          # set parent to nil for live_record before setting "real" parent.
          # live_record.parent = nil

          if (self.parent != nil)
            # no need to copy order value, as it's copied in the clone process
            # check draft.parent.published_record != nil, and set as parent
            if (self.parent != nil)
              if (self.parent.published_record != nil)
                live_record.parent = self.parent.published_record
              end
            end
          end
        end
        
        live_record.draft = false;
        live_record.updated_at = Time.now.utc if self.respond_to?("updated_at")
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

    end # Module Draft
  end # Module plugins
end # module MongoMapper
