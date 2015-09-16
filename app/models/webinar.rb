class Webinar < ActiveRecord::Base
  belongs_to :attachment
  belongs_to :bigbluebutton_room
  has_many :ligament_leads, dependent: :destroy

  def transfer_to_json
    as_json
  end

  def find_course
    attachment.attachmentable.course rescue nil
  end

  def create_room_in_schedule
    scheduler = Rufus::Scheduler.start_new
    server_bb = BigbluebuttonServer.last
    unless server_bb.present?
      server_bb = BigbluebuttonServer.create({name: "Webinars Ed",
                                              url: "http://78.47.73.50/bigbluebutton/api",
                                              salt: "74ab3f53f53e260406faeaa4bdbded35", version: "0.9"})
    end
    scheduler.at "#{date_start}" do
      bb = BigbluebuttonRoom.where(name: attachment.title).last
      bb = BigbluebuttonRoom.create({server_id: server_bb.id, name: attachment.title, moderator_key: "12345"}) if bb.blank?
      config_meeting = bb.server.api.create_meeting(bb.name, bb.meetingid, {duration: duration.to_i})
      bb.update({
                  meetingid: config_meeting[:meetingID],
                  attendee_api_password: config_meeting[:attendeePW],
                  moderator_api_password: config_meeting[:moderatorPW]
                })
      self.bigbluebutton_room_id = bb.id
      save
    end
    scheduler.start
  end

  def url_bigbluebuttom(user_id, type="user")
    bbbroom = bigbluebutton_room rescue nil
    if bbbroom.present?
      user = User.find(user_id)
      password = type == "user" ? bbbroom.attendee_api_password : bbbroom.moderator_api_password
      bbbroom.server.api.join_meeting_url(bbbroom.meetingid, user.full_name, password)
    end
  end

end
