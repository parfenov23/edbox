module ApplicationHelper
  def local_time(time)
    time + (User.time_zone).hour
  end

  def rub
    "руб."
  end

  def default_img(img)
    if img.present?
      img.scan(/http(.*):\/\//).present? ? img : "data:image/gif;base64,#{img}"
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

  # Заголовок страницы
  def layout_title
    d = @page_title.nil? ? "" : " | "
    @page_title.to_s + d + "ADCONSULT.Online"
  end

  def title(page_title=nil)
    @page_title = page_title
  end

  def page_title(default_title = '')
    @page_title || default_title
  end

  #################

  #Фоотер для страницы
  def page_footer_init(page_footer)
    @page_footer = page_footer
  end

  def page_footer
    @page_footer.nil? ? true : @page_footer
  end

  ##################

  def schedule_line
    [{month: 1, title: "Январь", r: 'Января'}, {month: 2, title: "Февраль", r: 'Февраля'},
     {month: 3, title: "Март", r: 'Марта'}, {month: 4, title: "Апрель", r: 'Апреля'},
     {month: 5, title: "Май", r: 'Мая'}, {month: 6, title: "Июнь", r: 'Июня'},
     {month: 7, title: "Июль", r: 'Июля'}, {month: 8, title: "Август", r: 'Августа'},
     {month: 9, title: "Сентябрь", r: 'Сентября'}, {month: 10, title: "Октябрь", r: 'Октября'},
     {month: 11, title: "Ноябрь", r: 'Ноября'}, {month: 12, title: "Декабрь", r: 'Декабря'}]
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

  def rus_schedule_line(n)
    schedule_line[n-1][:r]
  end

  def current_params
    hash_params = params
    hash_params.delete(:controller)
    hash_params.delete(:action)
    hash_params
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

  def social_share_link(soc_name, path, title, img)
    "http://www.addthis.com/bookmark.php?v=300&winname=addthis&lng=ru&s=#{soc_name}&url=#{$env_mode.current_domain + path}&title=#{title}
      &frommenu=1&uud=1&ct=1&uct=1&tt=0&captcha_provider=nucaptcha&picture=#{img}"
  end

  def user_news
    if current_user.present?
      no_read_news = current_user.no_read_news
      no_read_news_count = no_read_news.count
      if no_read_news_count < 5
        (no_read_news + current_user.read_news.last(5 - no_read_news_count)).sort.reverse
      end
    else
      News.last(5)
    end
  end

  def websocket_url
    (!$env_mode.prod? ? "#{request.host}:#{request.port}" : "#{request.host}:3001") + '/node/websocket'
  end

  def btn_edit
    raw "&#9998;"
  end

  def btn_delete
    raw "&#10006;"
  end

  def btn_complete
    raw "&#10003;"
  end

  def delete_confirm
    {onclick: "return confirm('Вы уверены что хотите удалить?')"}
  end

  def un_archive_confirm
    {onclick: "return confirm('Вы уверены что хотите востановить?')"}
  end

  def class_block_attachment(attachment)
    ad__active = attachment.announcement? ? 'is__unreacheble' : ''
    if current_user.present?
      (current_user.view_course?(@course) ? ad__active : 'is__unreacheble js_alertErrorSubscription')
    else
      (attachment.public ? ad__active : 'is__unreacheble js_openFormRegistration')
    end
  end

  def current_action
    params[:controller] + "/" + params[:action]
  end

  def split_string_two_part(string, max_size=40)
    first_string = ''
    last_string = ''
    string.split(' ').each do |s|
      first_string.length <= max_size ? (first_string += s + ' ') : last_string += s + ' '
    end
    return [first_string, last_string]
  end

  def array_table_tariff_info
    [['8 стартовых бесплатных базовых онлайн-курсов', true],
     ['Бесплатные вебинары экспертов 1 раз в 2 месяца', true],
     ['Бесплатные материалы в библиотеке', true],
     ['Все онлайн-курсы всех экспертов', [true, true, false]],
     ['Все вебинары в прямом эфире всех экспертов', [true, true, false]],
     ['Все материалы в библиотеке', [true, true, false]],
     ['Все будущие обновления онлайн-университета', [true, true, false]],
     ['Личный кабинет слушателя', [true, true, false]],
     ['Возможность формировать личное расписание', [true, true, false]],
     ['Возможность проверять собственные знания', [true, true, false]],
     ['Сертификат по окончании онлайн-курсов', [true, true, false]],
     ['Личный кабинет руководителя', [true, false, false]],
     ['Формирование групп слушателей и назначение группового расписания', [true, false, false]],
     ['Контроль за обучением сотрудников в личном кабинете ', [true, false, false]],
     ['Еженедельные отчеты о ходе обучения сотрудников', [true, false, false]],
     ['Персональные рекомендации по программе обучения и сопровождение академического директора ADCONSULT Online', [true, false, false]],
     ['Бонусные корпоративные программы  и предложения', [true, false, false]]]
  end
end
