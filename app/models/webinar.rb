class Webinar < ActiveRecord::Base
  belongs_to :attachment
  belongs_to :bigbluebutton_room
  has_many :ligament_leads, dependent: :destroy

  def transfer_to_json
    as_json
  end

  def course
    attachment.attachmentable.course
  end

  def find_course
    attachment.attachmentable.course rescue nil
  end

  def in_progress?
    minute_diff = (Time.now.utc - date_start).to_i/60
    (minute_diff > 0 && minute_diff < duration) ? true : false
  end

  def create_room
    server_bb = BigbluebuttonServer.last
    unless server_bb.present?
      server_bb = BigbluebuttonServer.create({name: "Adconsult Webinar",
                                              url: "http://95.213.182.34/bigbluebutton/api",
                                              salt: "e332144d6725ac8864d92cbf96ddb0df", version: "0.9"})
    end
    ActiveRecord::Base.connection_pool.with_connection do
      bb = BigbluebuttonRoom.where(name: attachment.title).last
      if bb.blank?
        leads_txt = '.'
        if ligament_leads.present?
          if ligament_leads.count == 1
            leads_txt = "вести сегодняшний вебинар будет #{ligament_leads.first.user.first_name}."
          else
            names = ligament_leads.pluck(:first_name)
            leads_txt = "вести сегодняшний вебинар будут #{names.joins(', ')}"
          end
        end
        welcome_msg = "Добро пожаловать на #{(course.title rescue nil)}: #{attachment.tile}. Начало вебинара запланировано на #{ltime(date_start, '', 'time')} по Москве#{leads_txt}"
        moderator_only_message = "1. Проверьте микрофон и камеру 2. Не забудьте настроить права участников 3. Проверьте записывается ли вебинар 4. Настройте white board, добавьте материалы"
        bb = BigbluebuttonRoom.create({
                                        server_id: server_bb.id,
                                        name: attachment.title,
                                        moderator_key: "12345",
                                        duration: 480,
                                        record_meeting: true,
                                        auto_start_recording: true,
                                        allow_start_stop_recording: true,
                                        welcome_msg: welcome_msg,
                                        moderator_only_message: moderator_only_message
                                      })
      end
      config_meeting = bb.server.api.create_meeting(bb.name, bb.meetingid)
      bb.update({
                  meetingid: config_meeting[:meetingID],
                  attendee_api_password: config_meeting[:attendeePW],
                  moderator_api_password: config_meeting[:moderatorPW]
                })
      self.bigbluebutton_room_id = bb.id
      save
    end
  end

  def url_bigbluebuttom(user_id, type="user")
    bbbroom = bigbluebutton_room rescue nil
    if bbbroom.present?
      user = User.find(user_id) rescue nil
      password = type == "user" ? bbbroom.attendee_api_password : bbbroom.moderator_api_password
      bbbroom.server.api.join_meeting_url(bbbroom.meetingid, (user.full_name rescue "Слушатель"), password)
    end
  end

end
