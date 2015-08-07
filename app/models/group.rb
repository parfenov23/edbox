class Group < ActiveRecord::Base
  belongs_to :company
  has_many :bunch_groups, :dependent => :destroy
  has_many :bunch_courses, :dependent => :destroy
  has_many :ligament_courses, :dependent => :destroy
  has_many :notifications, :as => :notifytable, :dependent => :destroy
  EXCEPT_ATTR = ["created_at", "updated_at"]

  def transfer_to_json
    result = as_json(:except => EXCEPT_ATTR)
    result
  end

  def all_courses
    Course.where(id: bunch_courses.pluck(:course_id).uniq)
  end

  def find_ligament_section(section_id)
    ligament_courses.joins(:ligament_sections)
      .where({"ligament_sections.section_id" => section_id}).first.
      ligament_sections.where(section_id: section_id).last rescue nil
  end

  def build_all_course
    ligament_courses.each do |ligament_course|
      course = ligament_course.course
      date_complete = (ligament_course.bunch_courses.last.date_complete.to_s rescue (Time.now + 2.day).to_s )
      BunchCourse.build(course.id, id, date_complete, 'group', nil)
    end
  end

  def notify_json(type=nil)
    {
      title: "Вас добавили в группу",
      body: "Вы добавлены в группу «#{first_name}»",
      timeClose: 0,
      linkGo: "/group?id=#{id}"
    }
  end

end
