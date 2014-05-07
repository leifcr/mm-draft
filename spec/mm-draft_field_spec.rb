require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'MongoMapper::Plugins::draft - field spec' do


  describe 'cages' do
    before(:each) do
      @cage = Cage.create(name: 'Large')
    end

    after(:each) do
      @cage.destroy
    end

    it 'should work on array' do
      @cage.tags = ['cow', 'dog', 'horse']
      @cage.save
      @cage.publish
      @cage.tags.count.should                  == 3
      @cage.published_record.tags.count.should == 3
      @cage.tags.should                        == @cage.published_record.tags
      @cage.tags = ['cow', 'dog']
      @cage.save
      @cage.publish
      @cage.tags.count.should                  == 2
      @cage.published_record.tags.count.should == 2
      @cage.tags.should                        == @cage.published_record.tags
    end

    it 'should work on integer' do
      @cage.number = 1
      @cage.save
      @cage.publish
      @cage.number.should                  == 1
      @cage.published_record.number.should == 1
      @cage.number                         =  2
      @cage.publish
      @cage.number.should                  == 2
      @cage.published_record.number.should == 2
    end

    it 'should update a string' do
      @cage.name                         =  'Small'
      @cage.publish
      @cage.name.should                  == 'Small'
      @cage.published_record.name.should == 'Small'
    end

    it 'should work on time' do
      t1 = Time.new.utc
      @cage.sometime = t1
      @cage.save
      @cage.publish
      @cage.sometime.should                  be_within(1.second).of(t1)
      @cage.published_record.sometime.should be_within(1.second).of(t1)
      @cage.published_record.sometime.should == @cage.sometime
      t2 = Time.new.utc
      @cage.sometime                         =  t2
      @cage.publish
      @cage.sometime.should                  be_within(1.second).of(t2)
      @cage.published_record.sometime.should be_within(1.second).of(t2)
      @cage.published_record.sometime.should == @cage.sometime
    end

    it 'should work on float' do
      @cage.pi = 3.14
      @cage.save
      @cage.publish
      @cage.pi.should                  == 3.14
      @cage.published_record.pi.should == 3.14
      @cage.pi                         =  3.14159265359
      @cage.save
      @cage.publish
      @cage.pi.should                  == 3.14159265359
      @cage.published_record.pi.should == 3.14159265359
    end



    it 'should work on hash' do
      @cage.a_hash = {
        animals: 'Cows, Dogs, Horses',
        places: 'London, Oslo, Guildford'
      }
      @cage.save
      @cage.publish
      @cage.a_hash.keys.count.should                  == 2
      @cage.published_record.a_hash.keys.count.should == 2
      @cage.a_hash.should                             == @cage.published_record.a_hash
      @cage.a_hash = {
        animals: 'Cows, Dogs, Horses',
        places: 'London, Oslo, Guildford',
        monitors: 'LG, Dell, Samsung'
      }
      @cage.save
      @cage.publish
      @cage.a_hash.keys.count.should                  == 3
      @cage.published_record.a_hash.keys.count.should == 3
      @cage.a_hash.should                             == @cage.published_record.a_hash
    end

  end
end
