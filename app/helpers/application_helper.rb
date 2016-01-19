module ApplicationHelper
  def local_time(time)
    time + (User.time_zone).hour
  end

  def rub
    "руб."
  end

  def default_img(img)
    if img.present?
      "data:image/gif;base64,#{img}"
    else
      "/images/ava.png"
    end
  end

  def text_type_material
    {"edit" => "Текст", "video" => "Видео",
     "audio" => "Аудио", "pdf" => "PDF", "img" => "Изображение",
     "file" => "Материал для скачивания", "test" => "Тест", "online__course" => "Вебинар"}
  end

  def ltime(time, add_text="", format='short_min', valid_translate=true)
    begin
      time_def = valid_translate ? local_time(time) : time
      add_text + (l time_def, :format => format.to_sym)
    rescue
      "Нет даты"
    end
  end

  def current_time
    local_time(Time.now)
  end

  def parse_russian_date(time)
    case time_current_day(time)
      when 0
        "Сегодня в #{time.strftime('%H:%M')}"
      when 1
        "Завтра в #{time.strftime('%H:%M')}"
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

  def current_domain(port=3000)
    $env_mode.current_domain
  end

  def layout_title
    d = @page_title.nil? ? "" : " | "
    @page_title.to_s + d + "ADCONSULT.Online"
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

  def make_up_where_from_date(time_from, time_to, frist_field="created_at >=", last_field="created_at <=")
    condition_where_arr = []
    time_where_arr = []
    if time_from.present?
      condition_where_arr << "#{frist_field} ?"
      time_where_arr << time_from
    end
    condition_where_arr << "and" if time_from.present? && time_to.present?
    if time_to.present?
      condition_where_arr << "#{last_field} ?"
      time_where_arr << time_to
    end
    array_where = [condition_where_arr.join(" ")]
    time_where_arr.each { |time_where| array_where << time_where }
    array_where
  end

  def rus_case(count, n1, n2, n3)
    "#{count} #{Russian.p(count, n1, n2, n3)}"
  end

  def profile_header_text(sub=nil)
    if sub.nil?
      {title: "У вас бесплатный аккаунт", desc: "Вы можете просматривать только бесплатные курсы и материалы", show_btn: true}
    else
      desc = if !sub.overdue? && !sub.overdue?(7)
               "Действует до #{ltime(sub.date_to, '', 'long_without_time')}"
             elsif sub.overdue?(7) && !sub.overdue?(1)
               r_day = sub.residue_day
               "Действует еще #{rus_case(r_day, 'день', 'дня', 'дней')}, продлите подписку"
             elsif sub.overdue?(1) && !sub.overdue?
               "Действует до завтра, продлите подписку"
             elsif sub.overdue? && !sub.overdue?(-1)
               "Подписка закончится сегодня"
             else
               "Подписка закончилась"
             end
      sub_title = sub.company? ? "Корпоративная подписка" : "Индивидуальная подписка"
      sub_class = sub.overdue?(3) ? "overdue" : ""
      sub_btn = sub.overdue?(7) ? true : false
      {title: sub_title, desc: desc, class: sub_class, show_btn: sub_btn}
    end
  end

  def rus_case_label(count, n1, n2, n3)
    "#{Russian.p(count, n1, n2, n3)}"
  end
end
