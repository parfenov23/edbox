class Webinar < ActiveRecord::Base
  belongs_to :attachment
  has_many :ligament_leads, dependent: :destroy
  has_many :user_webinars, :dependent => :destroy
  has_many :group_webinars, dependent: :destroy

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

  def auto_start
    minute_diff = (Time.now.utc - date_start).to_i/60
    eventRun if minute_diff >= -15 && !start?
  end

  def start?
    eventStatus == 'START'
  end

  def stop?
    eventStatus == 'STOP'
  end

  def eventCreate
    client = ::ApiClients::WebinarRu.new
    access = 'open'
    resp = client.get('Create.php', {name: attachment.title, time: date_start.to_i, description: attachment.title, access: access})
    if resp['event'].present? && resp['event']['status'] == 'ok'
      self.event = resp['event']['event_id'].to_i
      save
    end
  end

  def eventUpdate
    client = ::ApiClients::WebinarRu.new
    access = 'open'
    resp = client.get('Update.php', {event_id: self.event, name: attachment.title, time: date_start.to_i, description: attachment.title, access: access})
    resp['event'].present? && resp['event']['status'] == 'ok'
  end

  def eventStatus
    client = ::ApiClients::WebinarRu.new
    resp = client.get('GetStatus.php', {event_id: event})
    resp['event']['stage'] if resp['event'].present? && resp['event']['status'] == 'ok'
  end

  def eventRun(runStatus = 'START')
    update({status: runStatus})
    client = ::ApiClients::WebinarRu.new
    resp = client.get('Status.php', {event_id: event, stage: runStatus})
    resp['event'].present? && resp['event']['status'] == 'ok'
  end

  def eventStart
    eventRun('START')
  end

  def eventStop
    eventRun('STOP')
  end

  def eventRegUser(user, role='user')
    HomeMailer.reg_webinar(self, user).deliver
    client = ::ApiClients::WebinarRu.new
    resp = client.get('Register.php', {event_id: event, username: user.full_name, email: user.email, role: role})
    if resp['guestList'].present? && resp['guestList']['status'] == 'ok'
      user_webinar = UserWebinar.find_or_create_by(webinar_id: self.id, user_id: user.id)
      user_webinar.update(url: resp['guestList']['guest']['uri'])
    end
  end

  def eventUnRegUser(user)
    client = ::ApiClients::WebinarRu.new
    resp = client.delete('User.php', {event_id: event, email: user.email})
    if resp['user'].present? && resp['user']['status'] == 'ok'
      user_webinars.where(user_id: user.id).destroy_all
    end
  end
end
