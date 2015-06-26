module ApplicationHelper
  def local_time(time)
    time + (User.time_zone).hour
  end
end
