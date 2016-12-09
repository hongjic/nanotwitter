module TimeUtil

  def get_time_distance previous, current
    d = current - previous
    arr = [31536000, 2592000, 604800, 86400, 3600, 60, 1]
    unit = ["year", "month", "week", "day", "hour", "minute", "second"]
    7.times { |i| return "#{d/arr[i]} #{unit[i]}#{d/arr[i] > 1 ? "s" : ""}" if d/arr[i] > 0 }
    "0 second"
  end
  
end