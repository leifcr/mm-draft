$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'mongo_mapper'
#require 'pp'

#MongoMapper.database = 'testing'

# To create your own plugin, just create a module.
module MongoMapper
	module Plugins
		module Draft
		  
		  # ClassMethods module will automatically get extended
		  module ClassMethods
		  end
		
		  # InstanceMethods module will automatically get included
		  module InstanceMethods

				def draft?
					self.draft
				end
				
				def is_published?
					if draft?
	    			if (self.class.find(self.draft_record_published_id) != nil)
	    				true
  					end
    			else
    				true
					end
					false
				end
		    
		    def publish
		    	if (self.changed?)
		    		if (self.save == false)
		    			return false
		    		end
	    		end
	    		live_model = self.clone
		    	self.draft_record_published_id = live_model._id
		    	self.save!
		    	live_model.draft = false;
		    	live_model.save!
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
