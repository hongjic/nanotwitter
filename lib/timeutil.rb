module TimeUtil
  #inputs are integer
  def get_time_distance previous, current
    d = current - previous
    if (d/3600/24 > 0)
      dd = d/3600/24
      dd.to_s + (dd == 1 ? " day" : " days")
    elsif (d/3600 > 0)
      dd = d/3600
      dd.to_s + (dd == 1 ? " hour" : " hours")
    elsif (d/60 > 0)
      dd = d/60
      dd.to_s + (dd == 1 ? " minute" : " minutes")
    else
      dd.to_s + (dd == 1 ? " second" : " seconds")
    end
  end

end