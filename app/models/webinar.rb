class Webinar < ActiveRecord::Base
  belongs_to :attachment
  has_many :ligament_leads, dependent: :destroy
  has_many :user_webinars, :dependent => :destroy
  has_many :group_webinars, dependent: :destroy

  scope :start_close, ->(time) { where(id: where(["date_start >= ?", time-2.hour]).order("date_start ASC").select { |web| web.id if !web.stop? }) }
  scope :courses, -> { Course.where(id: all.map{|w| w.course.id rescue nil}) }

  def transfer_to_json
    as_json
  end

  def course
    attachment.attachmentable.course
  end

  def find_course
    attachment.attachmentable.course rescue nil
  end

  def clear_users
    user_webinars.each do |user_webinar|
      eventRegUser(user_webinar.user)
    end
    group_webinars.destroy_all
  end

  def in_progress?
    minute_diff = (Time.now.utc - date_start).to_i/60
    (minute_diff > 0 && minute_diff < duration) ? true : false
  end

  def leading?(user_id)
    ligament_leads.where(user_id: user_id).present?
  end

  def after_save
    eventUpdate if self.event.present?
  end

  def auto_start?
    valid_time_start? && !start?
  end

  def valid_time_start?
    minute_diff = (Time.now.utc - date_start).to_i/60
    minute_diff >= -15
  end

  def auto_start
    eventRun if auto_start?
  end

  def start?
    eventStatus == 'START'
  end

  def stop?
    eventStatus == 'STOP'
  end

  def active?
    eventStatus == 'ACTIVE'
  end

  def eventCreate
    webinar_title = attachment.attachmentable.course.title rescue Time.now.to_i
    resp = JSON.parse(event_client.post('events', 
      {
        name: webinar_title, startsAt: date_to_json, 
        description: webinar_title, access: 4
      }.compact))
    #binding.pry
    if resp['eventId'].present?
      self.event = resp['eventId'].to_i
      save
    end
  end

  def eventUpdate
    h_date = {
        name: attachment.title,
        startsAt: date_to_json, 
        description: attachment.title, access: 4
    }
    Thread.new {
      event_client = ::ApiClients::WebinarRu.new 
      event_client.put("organization/events/#{self.event}", h_date) 
      event_client.put("eventsessions/#{eventSession['id']}", h_date)
    }
    #JSON.parse(resp)['error'].blank? rescue resp == ""
    h_date
  end

  def eventStatus
    resp = eventInfo
    resp['eventSessions'].present? ? resp["eventSessions"].first['status'] : resp["status"]
  end

  def eventUrl
    session_id = eventSession['id']
    if url.blank? && session_id.present?
      self.url = "https://events.webinar.ru/adconsult/#{event}/stream/#{session_id}"
      save
    end
    url
  end

  def eventRecordUrl
    eventUrl.gsub("stream", "record")
  end

  def eventRecordInfo 
    JSON.parse(event_client.get("records?id=#{event}", {}))
  end

  def eventRecords(find=nil)
    resp = JSON.parse(event_client.get("records", {}))
    if find.present?
      resp = resp.detect {|f| f["link"] == find}
    end
    resp
  end

  def eventRecord
    id_note = eventRecords(eventRecordUrl)["id"]
    resp = JSON.parse(event_client.post("records/#{id_note}/conversions", {}))
    if resp.present?
      self.video_id = resp["id"]
      save
    end
    resp
  end

  def eventRecordStatus
    if video_id.present? 
      JSON.parse(event_client.get("records/conversions/#{video_id}", {}))["state"] 
    else
      eventRecord
      JSON.parse(event_client.get("records/conversions/#{video_id}", {}))["state"] 
    end
  end

  def eventFileInfo
    JSON.parse(event_client.get("fileSystem/file/#{video_id}", {}))
  end

  def eventInfo
    JSON.parse(event_client.get("organization/events/#{self.event}", {}))
  end

  def eventSession
    session = event_client.post("events/#{event}/sessions", {})
    session = JSON.parse(session)
    session = eventInfo['eventSessions'].first if session["error"].present?
    #binding.pry
    session["id"] = session["eventSessionId"] if session["eventSessionId"].present?
    session
  end

  def eventActive(status = 'ACTIVE')
    resp = event_client.put("organization/events/#{self.event}", { status: status })
    JSON.parse(resp)['error'].blank? rescue resp == ""
  end

  def eventRun(runStatus = 'START')
    update({status: runStatus})

    resp = event_client.put("eventsessions/#{eventSession['id']}/#{runStatus.downcase}", {})
    JSON.parse(resp)['error'].blank? rescue resp == ""
  end

  def eventStart
    eventRun('START')
  end

  def eventStop
    eventRun('STOP')
  end

  def eventRegUser(user, role='GUEST')
    HomeMailer.reg_webinar_lead(self, user).deliver if ligament_leads.where(user_id: user.id).present?

    resp = postRegUser({
        email: user.email,
        name: user.first_name, 
        secondName: user.last_name,
        role: role
      })
    user_webinar = UserWebinar.find_or_create_by(webinar_id: id, user_id: user.id)
    user_webinar.update(url: resp['link'], participant_id: resp['participationId']) if (resp['error'].blank? rescue resp == "")
    user_webinar
  end

  def eventRegDemoUser
    resp = postRegUser({
        email: SecureRandom.hex(6).to_s + "@bataline.ru",
        name: "Участник", 
        secondName: "Вебинара",
        role: 'GUEST'
      })
    resp
  end

  def eventUnRegUser(user)
    find_users_webinar = user_webinars.where(user_id: user.id)
    participant_id = find_users_webinar.where.not(participant_id: nil).first
    resp = event_client.post("/participations/delete", { "participationIds[0]" => participant_id}) if participant_id.present?
    find_users_webinar.destroy_all
  end

  def create_job(date_time_start = (date_start - 5.minute))
    WebinarMailJob.run(date_time_start, id)
  end

  def job
    WebinarMailJob.find(id)
  end

  def remove_job
    WebinarMailJob.remove(id)
  end

  def rebuild_job
    remove_job
    create_job
  end

  def postRegUser(params)
    JSON.parse(event_client.post("events/#{event}/register", params))
  end

  private

  def event_client
    ::ApiClients::WebinarRu.new
  end

  def date_to_json
    current_time = date_start.present? ? (date_start + 3.hour) : nil
    current_time.present? ? {
      date: {year: current_time.year, month: current_time.month, day: current_time.day}, 
      time: {hour: current_time.hour, minute: current_time.min} 
    } : {}
  end
end
