#
# Simple time serializer with two main functionalities:
# 1. Takes a time in seconds and converts it into a pretty string
# 2. Takes a pretty string and converts it into time in seconds
#
# Dependencies:
# ActiveSupport
#
class PrettyTime

  #
  # Serializes(if you will) time in seconds supplied as integer to a
  # pretty time string
  # Example:
  #
  #   PrettyTime.load(130)  # 2 minutes 10 seconds
  #
  def self.load(time_in_sec)
    pretty_time.load(time_in_sec)
  end

  #
  # De-serializes(if you will) a pretty time into time in seconds
  # Example:
  #
  #   PrettyTime.dump('2 minutes 10 seconds')  # 130
  #
  def self.dump(time_as_pretty_string)
    pretty_time.dump(time_as_pretty_string)
  end

  #
  # Creates an instance of itself if one does not exist
  #
  def self.pretty_time
    @pretty_time ||= Core.new
  end

  #
  # Core class which provides the entry point to other useful methods
  #
  class Core

    HOURS = "hours"
    MINUTES = "minutes"
    SECONDS = "seconds"

    #
    # Core method that does all the work
    #
    def load(time_in_sec)
      hours, minutes, seconds = hours_and_minutes_and_seconds(time_in_sec)

      pretty_time_string = "" 

      if has_hours?(hours)
        pretty_time_string << "#{with_suffix(hours, HOURS)}" 
      end

      if has_minutes?(minutes)
        if has_hours?(hours)
          pretty_time_string << " "
        end
        pretty_time_string << "#{with_suffix(minutes, MINUTES)}"
      end

      if has_seconds?(seconds)
        if has_hours?(hours) || has_minutes?(minutes)
          pretty_time_string << " "
        end
        pretty_time_string << "#{with_suffix(seconds, SECONDS)}"
      end

      pretty_time_string
    end

    #
    # Core method that does all the work
    #
    def dump(time_as_pretty_string)
      if match = /^(\d+) (hours?) (\d+) (minutes?) (\d+) (seconds?)/.match(time_as_pretty_string)
        return match[1].to_i.send(:"#{match[2]}").to_i + match[3].to_i.send("#{match[4]}").to_i + match[5].to_i
      elsif match = /^(\d+) (hours?) (\d+) (minutes?)/.match(time_as_pretty_string)
        return match[1].to_i.send(:"#{match[2]}").to_i + match[3].to_i.send("#{match[4]}").to_i
      elsif match = /^(\d+) (minutes?) (\d+) (seconds?)/.match(time_as_pretty_string)
        return match[1].to_i.send(:"#{match[2]}").to_i + match[3].to_i
      elsif match = /^(\d+) (hours?) (\d+) (seconds?)/.match(time_as_pretty_string)
        return match[1].to_i.send(:"#{match[2]}").to_i + match[3].to_i
      end
      time_as_pretty_string.gsub(/ hours?| minutes?| seconds?/, '').to_i.send(:"#{$&.strip}")
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
      #   1 hour 
      #   3 hours
      def with_suffix(value, type)
        if value > 1
          return "#{value} #{type}"
        end

        return "#{value} #{type.gsub(/s$/, '')}"
      end

    alias :has_hours? :non_zero?
    alias :has_minutes? :non_zero?
    alias :has_seconds? :non_zero?

  end

end
