module ApiClients
  class WebinarRu
    # 2. Мероприятия (вебинары)
    # 2.1 Создание мероприятия
    # http://my.webinar.ru/api0/Create.php?key={KEY}&name={NAME}&time={TIME}&description={DESRIPTION}&access={ACCESS}
    # 2.2 Изменение мероприятия
    # http://my.webinar.ru/api0/Update.php?key={KEY}&event_id={EVENT_ID}name={NAME}&time={TIME}&description={DESCRIPTION}&access={ACCESS}
    # 2.3  Удаление мероприятия
    # http://my.webinar.ru/api0/Delete.php?event_id={EVENT_ID}&key={KEY}
    # 2.4 Старт и завершение мероприятия
    # http://my.webinar.ru/api0/Status.php?key={KEY}&event_id={EVENT_ID}&stage=START
    # http://my.webinar.ru/api0/Status.php?key={KEY}&event_id={EVENT_ID}&stage=STOP
    # 2.5 Получение статуса мероприятия
    # http://my.webinar.ru/api0/GetStatus.php?key={KEY}&event_id={EVENT_ID}
    # 3. Участники
    # 3.1 Регистрация участников
    # http://my.webinar.ru/api0/Register.php?key={KEY}&event_id={EVENT_ID}&username={USERNAME}&role={ROLE}&email={EMAIL}
    # 3.2 Удаление участника
    # DELETE http://my.webinar.ru/api0/User.php?key={key}&email={email}&event_id={eventId}
    # 3.3 Проверка, зарегистрирован ли участник в мероприятии
    # GET http://my.webinar.ru/api0/User.php?key={key}&email={email}&event_id={eventId}
    # 4. Записи мероприятий
    # 4.1 Получение ссылки на онлайн-запись мероприятия
    # http://my.webinar.ru/api0/GetRecordLink.php?event_id={EVENT_ID}&key={KEY}
    # 4.2 Постановка записи на конвертацию
    # POST http://my.webinar.ru/api0/Record.php?key={key}&event_id={eventId}
    # 4.3 Просмотр статуса конвертации
    # GET http://my.webinar.ru/api0/Record.php?key={key}&event_id={eventId}
    # GET http://my.webinar.ru/api0/Record.php?key={key}
    # 5. Размещение интерфейса вебинара на сайте
    # <iframe src="http://my.webinar.ru/event/{eventId}/?t=1&export=1" width="1024" height="768" frameborder="0" style="border:none"></iframe>
    # 6. Скачивание фалов чата
    # http://my.webinar.ru/api0/GetChat.php?key={key}&event_id={eventId}
    # 7. Скачивание файлов заметок
    # http://my.webinar.ru/api0/GetNotes.php?key={key}&event_id={eventId}

    API_KEY = '8e73f6bde3ba1eea55d1aa50f3df9c48'
    BASE_URL = 'http://my.webinar.ru/api0/'

    def initialize
      @conn = Faraday.new(url: BASE_URL) do |faraday|
        faraday.request :json
        faraday.request :url_encoded
        faraday.response :json, :content_type => /\bjson$/
        faraday.response :xml, content_type: /\bxml$/
        faraday.adapter :net_http
      end
    end

    def get(path, params = {}, headers = {})
      @conn.get do |req|
        req.headers.merge!(headers)
        req.url path, params.merge(key: API_KEY)
      end.body
    rescue
      {}
    end

    # def post(path, params = {})
    #   @conn.post do |req|
    #     req.headers['Content-Type'] = 'application/json'
    #     req.url path, @credentials
    #     req.body = params.to_json
    #   end.body
    # rescue
    #   {}
    # end

    # def auth(login, hash)
    #   response = @conn.post('/private/api/auth.php', USER_LOGIN: login, USER_HASH: hash).body
    #   response['root']['auth'] == 'true'
    # rescue
    #   false
    # end
  end
end