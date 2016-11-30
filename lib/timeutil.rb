module TimeUtil
  #inputs are integer
  def get_time_distance previous, current
    d = current - previous
    if (d/3600/24/365 > 0)
      dd = d/3600/24/365
      dd.to_s + (dd == 1 ? " year" : " years")
    elsif (d/3600/24/30 > 0)
      dd = d/3600/24/30
      dd.to_s + (dd == 1 ? " month" : " months")
    elsif (d/3600/24/7 > 0)
      dd = d/3600/24/7
      dd.to_s + (dd == 1 ? " week" : " weeks")
    elsif (d/3600/24 > 0)
      dd = d/3600/24
      dd.to_s + (dd == 1 ? " day" : " days")
    elsif (d/3600 > 0)
      dd = d/3600
      dd.to_s + (dd == 1 ? " hour" : " hours")
    elsif (d/60 > 0)
      dd = d/60
      dd.to_s + (dd == 1 ? " minute" : " minutes")
    else
      d.to_s + (dd == 1 ? " second" : " seconds")
    end
  end

end