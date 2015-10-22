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

  def ltime(time, add_text="", format='short_min', valid_translate=true)
    time_def = valid_translate ? local_time(time) : time
    ((add_text + (l time_def, :format => format.to_sym)) rescue "Нет даты")
  end

  def current_time
    local_time(Time.now)
  end

  def parse_russian_date(time)
    case time_current_day(time)
      when 0
        "Сегодня #{time.strftime('%H:%M')}"
      when 1
        "Завтра #{time.strftime('%H:%M')}"
      else
        ltime(time, '', 'short', false)
    end
  end

  def time_current_day(time)
    end_time_day = time.end_of_day
    end_time_day_current = Time.now.end_of_day
    ((end_time_day - end_time_day_current).to_i / 60)/(24*60)
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

  def make_up_where_from_date(time_from, time_to)
    condition_where_arr = []
    time_where_arr = []
    if time_from.present?
      condition_where_arr << "created_at >= ?"
      time_where_arr << time_from
    end
    condition_where_arr << "and" if time_from.present? && time_to.present?
    if time_to.present?
      condition_where_arr << "created_at <= ?"
      time_where_arr << time_to
    end
    array_where = [condition_where_arr.join(" ")]
    time_where_arr.each{|time_where| array_where << time_where}
    array_where
  end

  def rus_case(count, n1, n2, n3)
    "#{count} #{Russian.p(count, n1, n2, n3)}"
  end

  def rus_case_label(count, n1, n2, n3)
    "#{Russian.p(count, n1, n2, n3)}"
  end
end
