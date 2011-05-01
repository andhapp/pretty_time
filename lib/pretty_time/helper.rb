module PrettyTime
  module Helper
    def hours_and_minutes_and_seconds(time_in_sec)
      minutes, seconds = minutes_and_seconds(time_in_sec)
      hours = 0
      if minutes >= 60
        hours = minutes / 60
        minutes = minutes % 60
      end
      [hours, minutes, seconds]
    end

    def minutes_and_seconds(time_in_sec)
      [time_in_sec / 60, time_in_sec % 60]
    end
    
    def non_zero?(value)
      value != 0
    end

    def with_suffix(value, type)
      if value > 1
        return "#{value} #{type}"
      end

      return "#{value} #{type.gsub(/s$/, '')}"
    end
    
  end
end
