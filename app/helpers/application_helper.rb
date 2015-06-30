module ApplicationHelper
  def local_time(time)
    time + (User.time_zone).hour
  end

  def default_img(img)
    if img.present?
      "data:image/gif;base64,#{img}"
    else
      "/images/ava.png"
    end
  end
end
