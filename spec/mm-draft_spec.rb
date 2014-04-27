require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MongoMapper::Plugins::draft" do


  describe "draft monkey records" do
    before(:each) do
      @monkey_1   = Monkey.create(:name => "Chip")
      @monkey_2   = Monkey.create(:name => "Unaton")
      @monkey_1.publish
    end

    after(:each) do
      @monkey_1.destroy
      @monkey_2.destroy
    end

    it "should have same name as draft" do
      @monkey_1.name.should == "Chip"
      @monkey_1.published_record.name.should == "Chip"
      @monkey_1.published_record.name.should == @monkey_1.name
    end

    it "should be published" do
      @monkey_1.published_record.should_not == nil
    end

    it "should not have same created time as draft" do
      @monkey_1.unpublish
      @monkey_1.publish
      @monkey_1.created_at.should_not == @monkey_1.published_record.created_at
    end

    it "should not be published" do
      @monkey_2.published?.should_not == true
      @monkey_2.published_record.should == nil
    end

    it "should not be draft" do
      @monkey_1.published_record.draft?.should_not == true
    end

    it "should be draft" do
      @monkey_2.draft?.should == true
    end

    it "should rename draft only" do
      @monkey_1.name = "Sagofon"
      @monkey_1.published_record.should_not == nil
      @monkey_1.name.should_not             == @monkey_1.published_record.name
    end

    it "should rename both draft and published record" do
      @monkey_1.name = "Sagofon"
      @monkey_1.publish
      @monkey_1.published_record.should_not == nil
      @monkey_1.name.should == @monkey_1.published_record.name
    end

    it "should have updated updated_at both published record" do
      @monkey_1.name ="Kake"
      @monkey_1.save
      Timecop.freeze(Time.now + 2.minutes) do
        @monkey_1.publish
        @monkey_1.published_record.updated_at.should_not == @monkey_1.updated_at
      end
    end

    it "should unpublish draft record" do
      @monkey_1.unpublish
      @monkey_1.published?.should_not      == true
      @monkey_1.published_record_id.should == nil
      @monkey_1.published_record.should    == nil
    end

    it "should unpublish published record directly" do
      # It is recommended to unpublish a draft record instead of unpublising a published record
      @monkey_1.publish # publish record again...
      @monkey_1.published_record.unpublish
      # reload monkey_1
      @monkey_1.reload
      @monkey_1.published?.should_not      == true
      @monkey_1.published_record_id.should == nil
      @monkey_1.published_record.should    == nil
    end

    it "should destroy published record only" do
      @monkey_2.publish
      tmp_id = @monkey_2.published_record_id
      @monkey_2.published_record.destroy
      @monkey_2.reload
      @monkey_2.published_record_id.should == nil
      @monkey_2.published_record.should    == nil
      @monkey_2.name.should                == "Unaton" # make sure we didn't loose the draft
      @monkey_2.published?.should_not      == true
      @monkey_2.draft?.should              == true
      Monkey.find(tmp_id).should           == nil
    end

    it "should destroy draft and published record" do
      @monkey_2.publish # publish record again...
      tmp_draft_id = @monkey_2._id
      tmp_published_id = @monkey_2.published_record_id
      @monkey_2.destroy
      # keep ID's in order to check that they are destroyed!
      Monkey.find(tmp_draft_id).should == nil
      Monkey.find(tmp_published_id).should == nil
    end

    it " should validate the id of the published record on the published record" do
      @monkey_1.published_record.published_record_id.should  == @monkey_1.published_record._id
      @monkey_1.draft_record_published_id.should            == @monkey_1.published_record.published_record_id
    end

    it "should not be able to publish a published record" do
      @monkey_1.published_record.publish.should == false
    end

    it "should return that a published_record is published" do
      @monkey_1.published_record.published?.should == true
    end

    it "should return false for published? if a published record has been deleted instead of destroyed" do
      @monkey_1.published_record.delete
      @monkey_1.published?.should == false
    end
  end # describe "draft monkey records" do

  describe "draft dog records with published_at" do
    before(:each) do
      @dog   = Dog.create(:name => "Chip")
    end

    after(:each) do
      @dog.destroy
    end

    it "should should set published_at when publishing" do
      time = Time.now
      Timecop.freeze(time + 2.days) do
        @dog.publish
        @dog.published_record.should_not                  == nil
        @dog.published_at.should_not                      == nil
        @dog.published_record.published_at.should_not     == nil
        @dog.published_record.published_at.should         == @dog.published_at
      end
      @dog.published_record.published_at.should_not        == time
    end
    
    it "should unset published_t when unpublishing" do 
      @dog.publish
      @dog.published_at.should_not == nil
      @dog.unpublish
      @dog.published_at.should     == nil
    end
    
  end

end # describe "MongoMapper::Plugins::draft" do
