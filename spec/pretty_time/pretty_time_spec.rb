require 'spec_helper'

describe "PrettyTime" do

  context "On request to #dump" do

    it 'should convert A hours to X seconds' do
      PrettyTime.dump("4 hours").should == 4.hours.to_i
    end

    it 'should convert B minutes to X seconds' do
      PrettyTime.dump("40 minutes").should == 40.minutes.to_i
    end

    it 'should return X seconds as X seconds' do
      PrettyTime.dump("40 seconds").should == 40
    end

    it 'should convert A hours B minutes to X seconds' do
      PrettyTime.dump("4 hours 40 minutes").should == 4.hours.to_i + 40.minutes.to_i
    end

    it 'should convert B minutes C seconds to X seconds' do
      PrettyTime.dump("40 minutes 30 seconds").should == 40.minutes.to_i + 30
    end

    it 'should convert A hours C seconds to X seconds' do
      PrettyTime.dump("4 hours 30 seconds").should == 4.hours.to_i + 30
    end

    it 'should convert A hours B minutes C seconds to X seconds' do
      PrettyTime.dump("4 hours 40 minutes 30 seconds").should == 4.hours.to_i + 40.minutes.to_i + 30
    end

    it 'should convert A hrs to X seconds' do
      PrettyTime.dump("4 hrs").should == 4.hours.to_i    
    end

    it 'should convert B mins to X seconds' do
      PrettyTime.dump("4 mins").should == 4.minutes.to_i
    end
    
    it 'should convert C secs to X seconds' do
      PrettyTime.dump("4 secs").should == 4
    end

    it 'should convert A h to X seconds' do
      PrettyTime.dump("4 h").should == 4.hours.to_i    
    end

    it 'should convert B m to X seconds' do
      PrettyTime.dump("4 m").should == 4.minutes.to_i
    end
    
    it 'should convert C s to X seconds' do
      PrettyTime.dump("4 s").should == 4
    end
    
    context "with fence post cases" do

      it 'should convert 1 hour to 3600 seconds' do
        PrettyTime.dump("1 hour").should == 3600
      end

      it 'should convert 1 minute to 60 seconds' do
        PrettyTime.dump("1 minute").should == 60
      end

      it 'should return 1 second as 1 second' do
        PrettyTime.dump("1 second").should == 1
      end

      it 'should convert 1 hour 1 minute to 3660 seconds' do
        PrettyTime.dump("1 hour 1 minute").should == 3660
      end

      it 'should convert 1 minute 1 second to 61 seconds' do
        PrettyTime.dump("1 minute 1 second").should == 61
      end

      it 'should convert 1 hour 1 minute 1 second to 3661 seconds' do
        PrettyTime.dump("1 hour 1 minute 1 second").should == 3661
      end

      it 'should convert 1 hr to 3600 seconds' do
        PrettyTime.dump("1 hr").should == 1.hours.to_i    
      end

      it 'should convert 1 min to 60 seconds' do
        PrettyTime.dump("1 min").should == 1.minutes.to_i
      end
      
      it 'should convert 1 sec to 1 second' do
        PrettyTime.dump("1 sec").should == 1
      end

      it 'should convert 1 hr to 3600 seconds' do
        PrettyTime.dump("1 h").should == 1.hours.to_i    
      end

      it 'should convert 1 min to 60 seconds' do
        PrettyTime.dump("1 m").should == 1.minutes.to_i
      end
      
      it 'should convert 1 sec to 1 second' do
        PrettyTime.dump("1 s").should == 1
      end
      
    end
  end

  context "On request to #load" do

    it 'should convert 7200 seconds to 2 hours' do
      PrettyTime.load(2.hours).should == "2 hours"
    end

    it 'should convert 600 seconds to 10 minutes' do
      PrettyTime.load(10.minutes.to_i).should == "10 minutes"
    end

    it 'should return 59 seconds as 59 seconds' do
      PrettyTime.load(59).should == "59 seconds"
    end

    it 'should convert 7800 seconds to 2 hours 10 minutes' do
      PrettyTime.load(2.hours.to_i + 10.minutes.to_i).should == "2 hours 10 minutes"
    end

    it 'should convert 7210 seconds to 2 hours 10 seconds' do
      PrettyTime.load(2.hours.to_i + 10).should == "2 hours 10 seconds"
    end

    it 'should convert 130 seconds to 2 minutes 10 seconds' do
      PrettyTime.load(2.minutes.to_i + 10).should == "2 minutes 10 seconds"
    end

    it 'should convert 7810 seconds to 2 hours 10 minutes 10 seconds' do
      PrettyTime.load(2.hours.to_i + 10.minutes.to_i + 10).should == "2 hours 10 minutes 10 seconds"
    end
    
    context "with configuration defined" do
      
      it 'with hours_suffix as hrs and minutes and seconds as default should convert 7800 seconds to 2 hrs 10 minutes' do
        PrettyTime.configuration do |config|
          config.hours_suffix = "hrs"
        end
        PrettyTime.load(2.hours.to_i + 10.minutes.to_i).should == "2 hrs 10 minutes"
      end

      it 'with minutes_suffix as mins and hours and seconds as default should convert 7800 seconds to 2 hours 10 mins' do
        PrettyTime.configuration do |config|
          config.hours_suffix = "hours"
          config.minutes_suffix = "mins"
        end
        PrettyTime.load(2.hours.to_i + 10.minutes.to_i).should == "2 hours 10 mins"
      end

      it 'with seconds_suffix as secs and minutes and hours as default should convert 7805 seconds to 2 hours 10 minutes 5 secs' do
        PrettyTime.configuration do |config|
          config.hours_suffix = "hours"
          config.minutes_suffix = "minutes"
          config.seconds_suffix = "secs"
        end
        PrettyTime.load(2.hours.to_i + 10.minutes.to_i + 5).should == "2 hours 10 minutes 5 secs"
      end
      
    end
    
    context "with fence post cases" do

      before(:each) do
        PrettyTime.configuration do |config|
          config.hours_suffix = "hours"
          config.minutes_suffix = "minutes"
          config.seconds_suffix = "seconds"
        end   
      end
      
      it 'should convert 3600 seconds to 1 hour' do
        PrettyTime.load(1.hours).should == "1 hour"
      end

      it 'should convert 60 seconds to 1 minute' do
        PrettyTime.load(1.minute.to_i).should == "1 minute"
      end

      it 'should return 1 second as 1 second' do
        PrettyTime.load(1).should == "1 second"
      end

      it 'should convert 3660 seconds to 1 hour 1 minute' do
        PrettyTime.load(1.hours.to_i + 1.minute.to_i).should == "1 hour 1 minute"
      end

      it 'should convert 3601 seconds to 1 hour 1 second' do
        PrettyTime.load(1.hours.to_i + 1).should == "1 hour 1 second"
      end

      it 'should convert 61 seconds to 1 minute 1 second' do
        PrettyTime.load(1.minutes.to_i + 1).should == "1 minute 1 second"
      end

      it 'should convert 3661 seconds to 1 hour 1 minute 1 second' do
        PrettyTime.load(1.hours.to_i + 1.minutes.to_i + 1).should == "1 hour 1 minute 1 second"
      end

      context "with configuration defined" do
        
        it 'with hours_suffix as hrs and minutes and seconds as default should convert 3610 seconds to 1 hr 10 minutes' do
          PrettyTime.configuration do |config|
            config.hours_suffix = "hrs"
          end
          PrettyTime.load(1.hours.to_i + 10.minutes.to_i).should == "1 hr 10 minutes"
        end

        it 'with minutes_suffix as mins and hours and seconds as default should convert 7260 seconds to 2 hours 1 min' do
          PrettyTime.configuration do |config|
            config.hours_suffix = "hours"
            config.minutes_suffix = "mins"
          end
          PrettyTime.load(2.hours.to_i + 1.minutes.to_i).should == "2 hours 1 min"
        end

        it 'with seconds_suffix as secs and minutes and hours as default should convert 7801 seconds to 2 hours 10 minutes 1 sec' do
          PrettyTime.configuration do |config|
            config.hours_suffix = "hours"
            config.minutes_suffix = "minutes"
            config.seconds_suffix = "secs"
          end
          PrettyTime.load(2.hours.to_i + 10.minutes.to_i + 1).should == "2 hours 10 minutes 1 sec"
        end
        
      end
      
    end

  end

end
