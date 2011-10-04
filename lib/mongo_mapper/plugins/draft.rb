#$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'mongo_mapper'

module MongoMapper
	module Plugins
		module Draft
 		  extend ActiveSupport::Concern
		  # ClassMethods module will automatically get extended
		  module ClassMethods
		  end
		
		  # InstanceMethods module will automatically get included
		  module InstanceMethods

				def draft?
					self.draft
				end
				
				def published?
					if draft?
	    			if (self.class.find(self.draft_record_published_id) != nil)
	    				return true
  					end
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
		    		if (self.save == false)
		    			return false
		    		end
	    		end

				rec = nil
	    		# remove parents from previous published record
	    		if (self.respond_to?("parent_id_field") && self.respond_to?("path_field") && self.respond_to?("depth_field"))
		    		if (self.published?)
		    			#keep id
		    			rec = self.published_record
		    			rec.parent = nil
		    			rec.save
	    			end
    			end
	    		
	    		live_record = self.clone
	    		
	    		if (rec != nil)
	    			live_record._id = rec._id
    			end
    			
		    	self.draft_record_published_id = live_record._id
		    	self.save!

		  		# check if ramdiv-acts_as_tree is present
	    		if (self.respond_to?("parent_id_field") && self.respond_to?("path_field") && self.respond_to?("depth_field"))
		    		# if so, remove the current parent
		    		# set parent to nil for live_record before setting "real" parent.
		    		live_record.parent = nil
	    			
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
		    	live_record.save!
		    	return true
	    	end
	    	
	    	def published_record
	    		if draft?
	    			self.class.find(self.draft_record_published_id)
    			else
    				self
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
    			if draft?
	    			published = self.class.find(self.draft_record_published_id)
	    			if (published != nil)
	    				published.destroy
	  				end
					end
  			end
  			
		  end # InstanceMethods
		  
		  def self.configure(model)
		    #puts "Configuring #{model}..."
		    model.key :draft, Boolean, :default => true
		
			  model.key :draft_record_published_id, ObjectId # points to the live page version if draft == true. else NIL
			  
			  # Before destroy callback to remove published record
			  model.before_destroy :unpublish
		  end
		end
	end
end
