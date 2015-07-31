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

  def current_link
    request.original_url.gsub("http://#{request.host}", "").gsub(":#{request.port}", "")
  end

  def layout_title
    d = @page_title.nil? ? "" : " | "
    @page_title.to_s + d + "Edbox"
  end

  def title(page_title)
    @page_title = page_title
  end

  def page_title(default_title = '')
    @page_title || default_title
  end

  def schedule_line
    [{month: 1, title: "Январь"}, {month: 2, title: "Февраль"},
     {month: 3, title: "Март"}, {month: 4, title: "Апрель"},
     {month: 5, title: "Май"}, {month: 6, title: "Июнь"},
     {month: 7, title: "Июль"}, {month: 8, title: "Август"},
     {month: 9, title: "Сентябрь"}, {month: 10, title: "Октябрь"},
     {month: 11, title: "Ноябрь"}, {month: 12, title: "Декабрь"}]
  end

  def rus_case(count, n1, n2, n3)
    "#{count} #{Russian.p(count, n1, n2, n3)}"
  end
end
