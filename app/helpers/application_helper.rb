module ApplicationHelper
  def local_time(time)
    time + (User.time_zone).hour
  end

  def default_img(img)
    unless img.nil?
      "data:image/gif;base64,#{img}"
    else
      "/images/ava.png"
    end
  end
end
