require 'test_helper'
require 'set'

class TestMongomapperActsAsTree < Test::Unit::TestCase
  context "record" do
    setup do
    	@monkey_1   = Monkey.create(:name => "Chip")
    	@monkey_2   = Monkey.create(:name => "Unaton")
    	@monkey_1.publish
    end

		should "have same name as draft" do
			assert_equal @monkey_1.name, "Chip"
			assert_equal @monkey_1.published_record.name, "Chip"
			assert_equal @monkey_1.published_record.name, @monkey_1.name
		end

    should "be published" do
      assert_not_nil(@monkey_1.published_record)
    end
    
    should "not be published" do
    	assert !@monkey_2.published?
    	assert_nil(@monkey_2.published_record)
  	end
  	
  	should "not be draft" do
  		assert !@monkey_1.published_record.draft?
		end
		
		should "be draft" do
			assert @monkey_2.draft?
		end
  	
  	should "rename draft only" do
  		@monkey_1.name = "Sagofon"
      assert_not_nil(@monkey_1.published_record)
  		assert_not_equal(@monkey_1.name, @monkey_1.published_record.name)
		end
		
		should "rename both draft and published record" do
  		@monkey_1.name = "Sagofon"
  		@monkey_1.publish
      assert_not_nil(@monkey_1.published_record)
  		assert_equal(@monkey_1.name, @monkey_1.published_record.name)
		end
	end
		
	context "tree-record" do
		setup do
	    @root_1     = Dog.create(:name => "Atmel")
	    @child_1    = Dog.create(:name => "ATmega644P", :parent => @root_1)
	    @child_2    = Dog.create(:name => "ATmega2561", :parent => @root_1)
	    @child_2_1  = Dog.create(:name => "ATtiny24", :parent => @child_2)
	
	    @root_2     = Dog.create(:name => "ST Ericsson")
	    @child_3    = Dog.create(:name => "ISP1181B", :parent => @root_2)

	    @root_1.publish
	    @child_1.publish
	    @child_2.publish
	    @child_2_1.publish
	    @root_2.publish
  	end
  	
		should "test draft record parents" do
  		assert_equal(@root_2, @child_3.parent)
  		assert_equal(@child_2, @child_2_1.parent)			
		end

  	should "test parents for published records" do
  		assert_equal(@root_1.published_record, @child_1.published_record.parent)
  		assert_equal(@root_1.published_record, @child_2.published_record.parent)
  		assert_equal(@child_2.published_record, @child_2_1.published_record.parent)
		end

		should "move draft record to new parent, but keep published at old parent" do
      @child_2.parent = @root_2
      
      assert !@root_2.is_or_is_ancestor_of?(@child_2_1)
      assert !@child_2_1.is_or_is_descendant_of?(@root_2)
      assert !@root_2.descendants.include?(@child_2_1)

      @child_2.save
      @child_2_1.reload

      assert @root_2.is_or_is_ancestor_of?(@child_2_1)
      assert @child_2_1.is_or_is_descendant_of?(@root_2)
      assert @root_2.descendants.include?(@child_2_1)

			# test published against root_1
      assert @root_1.published_record.is_or_is_ancestor_of?(@child_2_1.published_record)
      assert @child_2_1.published_record.is_or_is_descendant_of?(@root_1.published_record)
      assert @root_1.published_record.descendants.include?(@child_2_1.published_record)			
		end
		
		should "move both draft and published record to new parent" do
      @child_2.parent = @root_2
      
      assert !@root_2.is_or_is_ancestor_of?(@child_2_1)
      assert !@child_2_1.is_or_is_descendant_of?(@root_2)
      assert !@root_2.descendants.include?(@child_2_1)

			# can only test published after saving and publishing
			@child_2.save
      @child_2.publish # will also save
      @child_2.reload
      @child_2_1.reload

      assert @root_2.is_or_is_ancestor_of?(@child_2_1)
      assert @child_2_1.is_or_is_descendant_of?(@root_2)
      assert @root_2.descendants.include?(@child_2_1)

      assert @root_2.published_record.is_or_is_ancestor_of?(@child_2_1.published_record)
      assert @child_2_1.published_record.is_or_is_descendant_of?(@root_2.published_record)
      assert @root_2.published_record.descendants.include?(@child_2_1.published_record)
		end
		
		should "set a record as a root and check for ancestor" do
      @child_2.parent = nil
      
      assert !@root_2.is_or_is_ancestor_of?(@child_2_1)
      assert !@child_2_1.is_or_is_descendant_of?(@root_2)
      assert !@root_2.descendants.include?(@child_2_1)

			# can only test published after saving and publishing
			@child_2.save
      @child_2.publish # will also save
      @child_2.reload
      @child_2_1.reload

      assert @child_2.root?
      assert @child_2.published_record.root?
      assert @child_2_1.is_or_is_descendant_of?(@child_2)

      assert !@root_1.published_record.is_or_is_ancestor_of?(@child_2_1.published_record)
      assert !@child_2_1.published_record.is_or_is_descendant_of?(@root_1.published_record)
      assert !@root_1.published_record.descendants.include?(@child_2_1.published_record)			
		end
	
	end
end