class LigamentCourse < ActiveRecord::Base
  has_many :bunch_courses, dependent: :destroy
  belongs_to :course
  belongs_to :group
  has_many :ligament_sections , dependent: :destroy
  has_many :notifications, :as => :notifytable, dependent: :destroy

  def notify_json(type=nil)
    {
      title: "В вашу группу добавлен курс",
      body: "В вашу группу «#{group.first_name}» добавлен новый курс “#{course.title}",
      timeClose: 0,
      linkGo: "/group?id=#{group_id}&type=courses"
    }
  end

  def transfer_to_json
    as_json
  end
end
