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

    API_KEY = 'ac405d993e38d133d2a7e4c46c168333'
    BASE_URL = 'https://userapi.webinar.ru/v3/'

    def initialize
      @conn = Faraday.new(:url => BASE_URL)
    end

    def get(path, params = {}, headers = {'X-Auth-Token' => API_KEY})
      @conn.get do |req|
        req.headers.merge!(headers)
        req.url path, params.merge(key: API_KEY)
      end.body
    rescue
      {}
    end

    def delete(path, params = {}, headers = {})
      @conn.delete do |req|
        req.headers.merge!(headers)
        req.url path, params.merge(key: API_KEY)
      end.body
    rescue
      {}
    end

    def post(path, params = {}, headers = {'X-Auth-Token' => API_KEY})
      @conn.post do |req|
        req.headers.merge!(headers)
        req.url path
        req.body = params
      end.body
    rescue
      {}
    end

    def put(path, params = {}, headers = {'X-Auth-Token' => API_KEY})
      @conn.put do |req|
        req.headers.merge!(headers)
        req.url path
        req.body = params
      end.body
    rescue
      {}
    end

    # def auth(login, hash)
    #   response = @conn.post('/private/api/auth.php', USER_LOGIN: login, USER_HASH: hash).body
    #   response['root']['auth'] == 'true'
    # rescue
    #   false
    # end
  end
end