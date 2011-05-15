#
# Simple time serializer with two main functionalities:
# 1. Takes a time in seconds and converts it into a pretty string
# 2. Takes a pretty string and converts it into time in seconds
#
# Dependencies:
# ActiveSupport
#
class PrettyTime

  # Serializes(if you will) time in seconds supplied as integer to a
  # pretty time string
  # Example:
  #
  #   PrettyTime.load(130)  # 2 minutes 10 seconds
  def self.load(time_in_sec)
    pretty_time.load(time_in_sec)
  end

  # De-serializes(if you will) a pretty time into time in seconds
  # Example:
  #
  #   PrettyTime.dump('2 minutes 10 seconds')  # 130
  def self.dump(time_as_pretty_string)
    pretty_time.dump(time_as_pretty_string)
  end

  # Creates an instance of itself if one does not exist
  def self.pretty_time
    @pretty_time ||= Core.new
  end

  # Parent Class for unit's of time
  # for exaple: Hours, Minutes and Seconds
  class UnitOfTime
    attr_accessor :value
    
    def initialize(value)
      @value = value
    end

    def to_seconds
      @value 
    end
  end
  
  # Subclass of UnitofTime
  # converts hours into seconds
  class Hours < UnitOfTime
    def to_seconds
      @value.hours
    end
  end
  
  # Subclass of UnitofTime
  # converts minutes into seconds
  class Minutes < UnitOfTime
    def to_seconds
      @value.minutes
    end
  end

  # Subclass of UnitofTime  
  class Seconds < UnitOfTime
  end

  # Various mappings to allow one to pass in strings like:
  # 
  # 4 hours
  # 4 hrs
  # 4 h
  # Same goes for minutes and seconds.
  H = Hrs = Hr = Hour = Hours
  M = Mins = Min = Minute = Minutes
  S = Secs = Sec = Second = Seconds

  # Core class which provides the entry point to other useful methods
  class Core
    
    HOURS = "hours"
    MINUTES = "minutes"
    SECONDS = "seconds"

    # Core method that does all the work
    def load(time_in_secs)
      hours, minutes, seconds = hours_and_minutes_and_seconds(time_in_secs)

      time_as_pretty_string = "" 

      if has_hours?(hours)
        time_as_pretty_string << "#{with_suffix(hours, HOURS)}" 
      end

      if has_minutes?(minutes)
        if has_hours?(hours)
          time_as_pretty_string << " "
        end
        time_as_pretty_string << "#{with_suffix(minutes, MINUTES)}"
      end

      if has_seconds?(seconds)
        if has_hours?(hours) || has_minutes?(minutes)
          time_as_pretty_string << " "
        end
        time_as_pretty_string << "#{with_suffix(seconds, SECONDS)}"
      end

      time_as_pretty_string
    end

    # Core method that does all the work
    def dump(time_as_pretty_string)
      time_in_secs = 0
      match_data_as_array = match_it(time_as_pretty_string).to_a
      match_data_as_array.slice(1..match_data_as_array.length).each_slice(2).each do |match_array|
        time_in_secs += "PrettyTime::#{match_array[1].strip.classify}".constantize.new(match_array[0].to_i).to_seconds
      end

      time_in_secs
    end


    private
    
      # Converts time in seconds to an array of hours, minutes and seconds
      def hours_and_minutes_and_seconds(time_in_sec)
        minutes, seconds = minutes_and_seconds(time_in_sec)
        hours = 0
        if minutes >= 60
          hours = minutes / 60
          minutes = minutes % 60
        end
        [hours, minutes, seconds]
      end

      # Converts time in seconds to an array of minutes and seconds      
      def minutes_and_seconds(time_in_sec)
        [time_in_sec / 60, time_in_sec % 60]
      end

      # Checks if supplied value is zero
      def non_zero?(value)
        value != 0
      end

      # Adds the correct suffix 
      # Example:
      #
      #   1 hour # becuase it's == 1 so singular
      #   3 hours # becuase it's > 1 so plural
      def with_suffix(value, type)
        if value > 1
          return "#{value} #{type}"
        end

        return "#{value} #{type.gsub(/s$/, '')}"
      end

      # Takes a string (i.e. time as a string) and matches it against various regular expressions 
      # and returns the match as MatchData
      # Example:
      #   match_it("4 hours 40 minutes")
      #   match_it("4 hrs 40 mins")
      #   match_it("4 hrs 1 min")
      #
      def match_it(time_as_pretty_string)
        /^(\d+) (hours?) (\d+) (minutes?) (\d+) (seconds?)/.match(time_as_pretty_string) ||
        /^(\d+) (hours?) (\d+) (minutes?)/.match(time_as_pretty_string) ||
        /^(\d+) (minutes?) (\d+) (seconds?)/.match(time_as_pretty_string) ||
        /^(\d+) (hours?) (\d+) (seconds?)/.match(time_as_pretty_string) ||
        /^(\d+)( h| m| s)/.match(time_as_pretty_string) ||
        /^(\d+)( hours?| minutes?| seconds?)/.match(time_as_pretty_string)  ||
        /^(\d+)( hrs?| mins?| secs?)/.match(time_as_pretty_string)
      end
      
    alias :has_hours? :non_zero?
    alias :has_minutes? :non_zero?
    alias :has_seconds? :non_zero?

  end

end
