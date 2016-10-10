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
  
  #Фоотер для страницы
  def page_footer_init(page_footer)
    @page_footer = page_footer
  end

  def page_footer
    @page_footer.nil? ? true : @page_footer
  end
  
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
     ['Контроль за обучением сотрудников в личном кабинете', [true, false, false]],
     ['Еженедельные отчеты о ходе обучения сотрудников', [true, false, false]],
     ['Персональные рекомендации по программе обучения и сопровождение академического директора ADCONSULT Online', [true, false, false]],
     ['Бонусные корпоративные программы  и предложения', [true, false, false]]]
  end

  def array_mask_code_phone
    [["Россия", "+7(999)999-99-99"],["Остров Вознесения", "+247-9999"], ["Андорра", "+376-999-999"],
     ["Афганистан", "+93-99-999-9999"], ["Антигуа и Барбуда", "+1(268)999-9999"],
     ["Ангилья", "+1(264)999-9999"], ["Албания", "+355(999)999-999"],
     ["Армения", "+374-99-999-999"], ["Ангола", "+244(999)999-999"],
     ["Аргентина", "+54(999)999-9999"], ["Американское Самоа", "+1(684)999-9999"],
     ["Австрия", "+43(999)999-9999"], ["Австралия", "+61-9-9999-9999"],
     ["Аруба", "+297-999-9999"], ["Азербайджан", "+994-99-999-99-99"],
     ["Босния и Герцеговина", "+387-99-99999"], ["Босния и Герцеговина", "+387-99-9999"],
     ["Барбадос", "+1(246)999-9999"], ["Бангладеш", "+880-99-999-999"],
     ["Бельгия", "+32(999)999-999"], ["Болгария", "+359(999)999-999"],["Беларусь (Белоруссия)", "+375(99)999-99-99"],
     ["Бахрейн", "+973-9999-9999"], ["Бурунди", "+257-99-99-9999"],
     ["Бенин", "+229-99-99-9999"], ["Боливия", "+591-9-999-9999"],
     ["Бразилия", "+55(99)9999-9999"], ["Бразилия", "+55(99)7999-9999"],
     ["Бразилия", "+55(99)99999-9999"], ["Багамские Острова", "+1(242)999-9999"],
     ["Бутан", "+975-17-999-999"], ["Бутан", "+975-9-999-999"],
     ["Ботсвана", "+267-99-999-999"], ["Белиз", "+501-999-9999"],
     ["Центральноафриканская Республика", "+236-99-99-9999"],
     ["Швейцария", "+41-99-999-9999"], ["Острова Кука", "+682-99-999"],
     ["Чили", "+56-9-9999-9999"], ["Камерун", "+237-9999-9999"],
     ["Колумбия", "+57(999)999-9999"], ["Коста-Рика", "+506-9999-9999"],
     ["Куба", "+53-9-999-9999"], ["Кабо-Верде", "+238(999)99-99"],
     ["Кюрасао", "+599-999-9999"], ["Кипр", "+357-99-999-999"],
     ["Чехия", "+420(999)999-999"], ["Германия", "+49(9999)999-9999"],
     ["Германия", "+49(999)999-9999"], ["Германия", "+49(999)99-9999"],
     ["Германия", "+49(999)99-999"], ["Германия", "+49(999)99-99"],
     ["Германия", "+49-999-999"], ["Джибути", "+253-99-99-99-99"],
     ["Дания", "+45-99-99-99-99"], ["Доминика", "+1(767)999-9999"],
     ["Доминиканская Республика", "+1(809)999-9999"],
     ["Доминиканская Республика", "+1(829)999-9999"],
     ["Доминиканская Республика", "+1(849)999-9999"], ["Алжир", "+213-99-999-9999"],
     ["Эквадор", "+593-9-999-9999"], ["Эстония", "+372-999-9999"],
     ["Египет", "+20(999)999-9999"], ["Эритрея", "+291-9-999-999"],
     ["Испания", "+34(999)999-999"], ["Эфиопия", "+251-99-999-9999"],
     ["Финляндия", "+358(999)999-99-99"], ["Фиджи", "+679-99-99999"],
     ["Фолклендские острова", "+500-99999"], ["Фарерские острова", "+298-999-999"],
     ["Франция", "+33(999)999-999"], ["Сен-Пьер и Микелон", "+508-99-9999"],
     ["Гваделупа", "+590(999)999-999"], ["Габон", "+241-9-99-99-99"],
     ["Гренада", "+1(473)999-9999"], ["Грузия", "+995(999)999-999"],
     ["Гана", "+233(999)999-999"], ["Гибралтар", "+350-999-99999"],
     ["Гренландия", "+299-99-99-99"], ["Гамбия", "+220(999)99-99"],
     ["Гвинея", "+224-99-999-999"], ["Экваториальная Гвинея", "+240-99-999-9999"], ["Греция", "+30(999)999-9999"], ["Гватемала", "+502-9-999-9999"],
     ["Гуам", "+1(671)999-9999"], ["Гайана", "+592-999-9999"], ["Гонконг", "+852-9999-9999"], ["Гондурас", "+504-9999-9999"], ["Хорватия", "+385-99-999-999"],
     ["Гаити", "+509-99-99-9999"], ["Венгрия", "+36(999)999-999"], ["Индонезия", "+62-99-999-99"], ["Индонезия", "+62-99-999-999"], ["Индонезия", "+62-99-999-9999"],
     ["Ирландия", "+353(999)999-999"], ["Израиль", "+972-9-999-9999"], ["Индия", "+91(9999)999-999"], ["Диего-Гарсия", "+246-999-9999"], ["Ирак", "+964(999)999-9999"],
     ["Иран", "+98(999)999-9999"], ["Исландия", "+354-999-9999"], ["Италия", "+39(999)9999-999"], ["Ямайка", "+1(876)999-9999"], ["Иордания", "+962-9-9999-9999"],
     ["Япония", "+81(999)999-999"], ["Кения", "+254-999-999999"], ["Киргизия", "+996(999)999-999"], ["Камбоджа", "+855-99-999-999"], ["Кирибати", "+686-99-999"],
     ["Сент-Китс и Невис", "+1(869)999-9999"], ["Кувейт", "+965-9999-9999"], ["Каймановы острова", "+1(345)999-9999"], ["Казахстан", "+7(699)999-99-99"],
     ["Казахстан", "+7(799)999-99-99"], ["Лаос", "+856-99-999-999"], ["Ливан", "+961-9-999-999"], ["Сент-Люсия", "+1(758)999-9999"], ["Лихтенштейн", "+423(999)999-9999"],
     ["Шри-Ланка", "+94-99-999-9999"], ["Либерия", "+231-99-999-999"], ["Литва", "+370(999)99-999"], ["Латвия", "+371-99-999-999"], ["Ливия", "+218-99-999-999"],
     ["Ливия", "+218-21-999-9999"], ["Марокко", "+212-99-9999-999"], ["Монако", "+377(999)999-999"], ["Монако", "+377-99-999-999"], ["Черногория", "+382-99-999-999"],
     ["Мадагаскар", "+261-99-99-99999"], ["Маршалловы Острова", "+692-999-9999"], ["Мали", "+223-99-99-9999"], ["Монголия", "+976-99-99-9999"],
     ["Молдова", "+373-9999-9999"],
     ["Макао", "+853-9999-9999"], ["Мартиника", "+596(999)99-99-99"], ["Мавритания", "+222-99-99-9999"], ["Монтсеррат", "+1(664)999-9999"], ["Маврикий", "+230-999-9999"],
     ["Мальдивские острова", "+960-999-9999"], ["Малави", "+265-1-999-999"], ["Малави", "+265-9-9999-9999"], ["Мексика", "+52(999)999-9999"], ["Мексика", "+52-99-99-9999"],
     ["Малайзия", "+60(999)999-999"], ["Малайзия", "+60-99-999-999"], ["Малайзия", "+60-9-999-999"], ["Мозамбик", "+258-99-999-999"], ["Намибия", "+264-99-999-9999"],
     ["Новая Каледония", "+687-99-9999"], ["Нигер", "+227-99-99-9999"], ["Нигерия", "+234(999)999-9999"], ["Нигерия", "+234-99-999-999"], ["Нигерия", "+234-99-999-99"],
     ["Нидерланды", "+31-99-999-9999"], ["Норвегия", "+47(999)99-999"], ["Непал", "+977-99-999-999"], ["Науру", "+674-999-9999"], ["Ниуэ", "+683-9999"],
     ["Новая Зеландия", "+64(999)999-999"], ["Новая Зеландия", "+64-99-999-999"], ["Новая Зеландия", "+64(999)999-9999"], ["Оман", "+968-99-999-999"],
     ["Панама", "+507-999-9999"], ["Перу", "+51(999)999-999"], ["Филиппины", "+63(999)999-9999"], ["Пакистан", "+92(999)999-9999"], ["Палестина", "+970-99-999-9999"],
     ["Португалия", "+351-99-999-9999"], ["Парагвай", "+595(999)999-999"], ["Катар", "+974-9999-9999"], ["Реюньон", "+262-99999-9999"],
     ["Руанда", "+250(999)999-999"], ["Соломоновы Острова", "+677-99999"], ["Сейшелы", "+248-9-999-999"], ["Сингапур", "+65-9999-9999"], ["Словения", "+386-99-999-999"],
     ["Словакия", "+421(999)999-999"], ["Сьерра-Леоне", "+232-99-999999"], ["Сан-Марино", "+378-9999-999999"], ["Сенегал", "+221-99-999-9999"], ["Сомали", "+252-99-999-999"],
     ["Сомали", "+252-9-999-999"], ["Суринам", "+597-999-999"], ["Южный Судан", "+211-99-999-9999"], ["Сан-Томе и Принсипи", "+239-99-99999"], ["Сальвадор", "+503-99-99-9999"],
     ["Свазиленд", "+268-99-99-9999"], ["Того", "+228-99-999-999"], ["Таиланд", "+66-99-999-999"], ["Таджикистан", "+992-99-999-9999"], ["Токелау", "+690-9999"],
     ["Восточный Тимор", "+670-999-9999"], ["Восточный Тимор", "+670-77#-99999"], ["Восточный Тимор", "+670-789-99999"], ["Туркменистан", "+993-9-999-9999"],
     ["Тунис", "+216-99-999-999"], ["Тонга", "+676-99999"], ["Турция", "+90(999)999-9999"], ["Тринидад и Тобаго", "+1(868)999-9999"], ["Тувалу", "+688-29999"],
     ["Тайвань", "+886-9-9999-9999"], ["Тайвань", "+886-9999-9999"], ["Танзания", "+255-99-999-9999"], ["Украина", "+380(99)999-99-99"], ["Великобритания", "+44-99-9999-9999"],
     ["Уругвай", "+598-9-999-99-99"], ["Узбекистан", "+998-99-999-9999"], ["Ватикан", "+39-6-698-99999"], ["Сент-Винсент и Гренадины", "+1(784)999-9999"], ["Венесуэла", "+58(999)999-9999"],
     ["Вьетнам", "+84-99-9999-999"], ["Вьетнам", "+84(999)9999-999"], ["Вануату", "+678-99999"], ["Уоллис и Футуна", "+681-99-9999"], ["Самоа", "+685-99-9999"], ["Йемен", "+967-9-999-999"],
     ["Йемен", "+967-99-999-999"], ["Замбия", "+260-99-999-9999"], ["Зимбабве", "+263-9-999999"]].uniq.sort + [["Другое", ""]]
  end
end
