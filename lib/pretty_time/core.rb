module PrettyTime

  class Core

    extend PrettyTime::Helper

    HOURS = "hours"
    MINUTES = "minutes"
    SECONDS = "seconds"
    
    class << self
      #
      # Converts seconds to pretty string
      #
      #
      def load(time_in_sec)
        hours, minutes, seconds = hours_and_minutes_and_seconds(time_in_sec)
        
        if non_zero?(hours) && non_zero?(minutes) && non_zero?(seconds)
          return "#{with_suffix(hours, HOURS)} #{with_suffix(minutes, MINUTES)} #{with_suffix(seconds, SECONDS)}"
        elsif non_zero?(hours) && non_zero?(minutes)
          return "#{with_suffix(hours, HOURS)} #{with_suffix(minutes, MINUTES)}"
        elsif non_zero?(hours) && non_zero?(seconds)
          return "#{with_suffix(hours, HOURS)} #{with_suffix(seconds, SECONDS)}"
        elsif non_zero?(minutes) && non_zero?(seconds)
          return "#{with_suffix(minutes, MINUTES)} #{with_suffix(seconds, SECONDS)}"          
        elsif non_zero?(hours)
          return "#{with_suffix(hours, HOURS)}"      
        elsif non_zero?(minutes)
          return "#{with_suffix(minutes, MINUTES)}"
        elsif non_zero?(seconds)
          return "#{with_suffix(seconds, SECONDS)}"          
        end

      end
    
      # 
      #
      # Converts pretty string to seconds
      #
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

    end

  end

end
