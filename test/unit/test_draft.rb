require 'test_helper'

class DraftTest < Test::Unit::TestCase
  context "draft monkey records" do
    setup do
      @monkey_1   = Monkey.create(:name => "Chip")
      @monkey_2   = Monkey.create(:name => "Unaton")
      @monkey_1.publish
    end

    should "have same name as draft" do
      @monkey_1.name.should == "Chip"
      @monkey_1.published_record.name.should == "Chip"
      @monkey_1.published_record.name.should == @monkey_1.name
    end

    should "be published" do
      @monkey_1.published_record.should_not == nil
    end
    
    should "not have same created time as draft" do
      @monkey_1.unpublish 
      @monkey_1.publish
      @monkey_1.created_at.should_not == @monkey_1.published_record.created_at
    end
    
    should "not be published" do
      @monkey_2.published?.should_not == true
      @monkey_2.published_record.should == nil
    end
    
    should "not be draft" do
      @monkey_1.published_record.draft?.should_not == true
    end
    
    should "be draft" do
      @monkey_2.draft?.should == true
    end
    
    should "rename draft only" do
      @monkey_1.name = "Sagofon"
      @monkey_1.published_record.should_not == nil
      @monkey_1.name.should_not == @monkey_1.published_record.name
    end
    
    should "rename both draft and published record" do
      @monkey_1.name = "Sagofon"
      @monkey_1.publish
      @monkey_1.published_record.should_not == nil
      @monkey_1.name.should == @monkey_1.published_record.name
    end

    should "have updated updated_at both published record" do
      @monkey_1.name ="Kake"
      @monkey_1.save
      @monkey_1.publish
      @monkey_1.published_record.updated_at.should_not == @monkey_1.updated_at
    end

    should "unpublish draft record" do
      @monkey_1.unpublish
      assert !@monkey_1.published?
      @monkey_1.published_record_id.should == nil
      @monkey_1.published_record.should == nil
    end

    should "unpublish published record directly" do
      # It is recommended to unpublish a draft record instead of unpublising a published record
      @monkey_1.publish # publish record again...
      @monkey_1.published_record.unpublish
      # reload monkey_1
      @monkey_1.reload
      @monkey_1.published?.should_not == true
      @monkey_1.published_record_id.should == nil
      @monkey_1.published_record.should == nil
    end

    should "destroy published record only" do
      @monkey_2.publish
      tmp_id = @monkey_2.published_record_id
      @monkey_2.published_record.destroy
      @monkey_2.reload
      @monkey_2.published_record_id.should == nil
      @monkey_2.published_record.should == nil
      @monkey_2.name.should == "Unaton" # make sure we didn't loose the draft
      @monkey_2.published?.should_not == true
      @monkey_2.draft?.should == true
      Monkey.find(tmp_id).should == nil
    end

    should "destroy draft and published record" do
      @monkey_2.publish # publish record again...
      tmp_draft_id = @monkey_2._id
      tmp_published_id = @monkey_2.published_record_id
      @monkey_2.destroy
      # keep ID's in order to check that they are destroyed!
      Monkey.find(tmp_draft_id).should == nil
      Monkey.find(tmp_published_id).should == nil
    end

  end # context "draft monkey records" do
    
  # context "tree-record" do
  #   setup do
  #     @root_1     = Dog.create(:name => "Atmel")
  #     @child_1    = Dog.create(:name => "ATmega644P", :parent => @root_1)
  #     @child_2    = Dog.create(:name => "ATmega2561", :parent => @root_1)
  #     @child_2_1  = Dog.create(:name => "ATtiny24", :parent => @child_2)
  
  #     @root_2     = Dog.create(:name => "ST Ericsson")
  #     @child_3    = Dog.create(:name => "ISP1181B", :parent => @root_2)

  #     @root_1.publish
  #     @child_1.publish
  #     @child_2.publish
  #     @child_2_1.publish
  #     @root_2.publish
  #   end
    
  #   should "test draft record parents" do
  #     assert_equal(@root_2, @child_3.parent)
  #     assert_equal(@child_2, @child_2_1.parent)     
  #   end

  #   should "test parents for published records" do
  #     assert_equal(@root_1.published_record, @child_1.published_record.parent)
  #     assert_equal(@root_1.published_record, @child_2.published_record.parent)
  #     assert_equal(@child_2.published_record, @child_2_1.published_record.parent)
  #   end

  #   should "move draft record to new parent, but keep published at old parent" do
  #     @child_2.parent = @root_2
      
  #     assert !@root_2.is_or_is_ancestor_of?(@child_2_1)
  #     assert !@child_2_1.is_or_is_descendant_of?(@root_2)
  #     assert !@root_2.descendants.include?(@child_2_1)

  #     @child_2.save
  #     @child_2_1.reload

  #     assert @root_2.is_or_is_ancestor_of?(@child_2_1)
  #     assert @child_2_1.is_or_is_descendant_of?(@root_2)
  #     assert @root_2.descendants.include?(@child_2_1)

  #     # test published against root_1
  #     assert @root_1.published_record.is_or_is_ancestor_of?(@child_2_1.published_record)
  #     assert @child_2_1.published_record.is_or_is_descendant_of?(@root_1.published_record)
  #     assert @root_1.published_record.descendants.include?(@child_2_1.published_record)     
  #   end
    
  #   should "move both draft and published record to new parent" do
  #     @child_2.parent = @root_2
      
  #     assert !@root_2.is_or_is_ancestor_of?(@child_2_1)
  #     assert !@child_2_1.is_or_is_descendant_of?(@root_2)
  #     assert !@root_2.descendants.include?(@child_2_1)

  #     # can only test published after saving and publishing
  #     @child_2.save
  #     @child_2.publish # will also save
  #     @child_2.reload
  #     @child_2_1.reload

  #     assert @root_2.is_or_is_ancestor_of?(@child_2_1)
  #     assert @child_2_1.is_or_is_descendant_of?(@root_2)
  #     assert @root_2.descendants.include?(@child_2_1)

  #     assert @root_2.published_record.is_or_is_ancestor_of?(@child_2_1.published_record)
  #     assert @child_2_1.published_record.is_or_is_descendant_of?(@root_2.published_record)
  #     assert @root_2.published_record.descendants.include?(@child_2_1.published_record)
  #   end
    
  #   should "set a record as a root and check for ancestor" do
  #     @child_2.parent = nil
      
  #     assert !@root_2.is_or_is_ancestor_of?(@child_2_1)
  #     assert !@child_2_1.is_or_is_descendant_of?(@root_2)
  #     assert !@root_2.descendants.include?(@child_2_1)

  #     # can only test published after saving and publishing
  #     @child_2.save
  #     @child_2.publish # will also save
  #     @child_2.reload
  #     @child_2_1.reload

  #     assert @child_2.root?
  #     assert @child_2.published_record.root?
  #     assert @child_2_1.is_or_is_descendant_of?(@child_2)

  #     assert !@root_1.published_record.is_or_is_ancestor_of?(@child_2_1.published_record)
  #     assert !@child_2_1.published_record.is_or_is_descendant_of?(@root_1.published_record)
  #     assert !@root_1.published_record.descendants.include?(@child_2_1.published_record)      
  #   end
end
