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

  def rus_case(count, n1, n2, n3)
    "#{count} #{Russian.p(count, n1, n2, n3)}"
  end
end
