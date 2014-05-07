require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MongoMapper::Plugins::draft - with embedded" do


  describe "cages" do
    before(:each) do
      @cage = Cage.create(name: "Large")
    end

    after(:each) do
      @cage.destroy
    end

    it "should have one embedded horse after publishing" do
      @cage.horse = Horse.new(name: "Super blinker")
      @cage.save
      @cage.publish
      @cage.published_record.horse.name.should == @cage.horse.name
    end

    it "should have three rats after publishing" do
      @cage.rats << Rat.new(name: "Rat 1")
      @cage.rats << Rat.new(name: "Rat 2")
      @cage.rats << Rat.new(name: "Rat 3")
      @cage.save
      @cage.publish
      @cage.rats.count.should == 3
      @cage.published_record.rats.count.should == 3
      @cage.published_record.rats.should == @cage.rats
    end

    it "should update a horse" do
    end

    it "should update all rats" do
      @cage.rats << Rat.new(name: "Rat 1")
      @cage.rats << Rat.new(name: "Rat 2")
      @cage.rats << Rat.new(name: "Rat 3")
      @cage.save
      @cage.publish
      @cage.rats.each do |rat|
        rat.name.include?("New Rat").should == false
      end
      @cage.published_record.rats.each do |rat|
        rat.name.include?("New Rat").should == false
      end

      @cage.rats.each do |rat|
        rat.name = "New #{rat.name}"
      end
      @cage.save
      @cage.publish
      @cage.rats.each do |rat|
        rat.name.include?("New Rat").should == true
      end
      @cage.published_record.rats.each do |rat|
        rat.name.include?("New Rat").should == true
      end
    end

    it "should remove one rat" do
      @cage.rats << Rat.new(name: "Rat 1")
      @cage.rats << Rat.new(name: "Rat 2")
      @cage.rats << Rat.new(name: "Rat 3")
      @cage.save
      @cage.publish
      @cage.published_record.rats.count.should == 3
      @cage.rats.delete_if {|rat| rat.name == "Rat 1"}
      @cage.save
      @cage.publish
      @cage.published_record.rats.count.should == 2
    end

  end
end
