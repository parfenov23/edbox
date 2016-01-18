class Group < ActiveRecord::Base
  belongs_to :company
  has_many :bunch_groups, :dependent => :destroy
  has_many :bunch_courses, :dependent => :destroy
  has_many :ligament_courses, :dependent => :destroy
  has_many :notifications, :as => :notifytable, :dependent => :destroy
  has_one :group_webinar, dependent: :destroy

  scope :all_users, -> { User.where(id: joins(:bunch_groups).select('bunch_groups.user_id').map(&:user_id)) }
  scope :all_courses, -> { Course.where(id: joins(:bunch_courses).select('bunch_courses.course_id').map(&:course_id)) }

  EXCEPT_ATTR = ["created_at", "updated_at"]

  def transfer_to_json
    result = as_json({except: EXCEPT_ATTR, include: :ligament_courses})
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
      date_complete_ligament = ligament_course.date_complete.to_s rescue nil
      date_complete = date_complete_ligament.present? ? date_complete_ligament : (Time.now + 2.day).to_s
      BunchCourse.build(course.id, id, date_complete, 'group', nil)
    end
  end

  def schedule
    ligament_courses_and_sections = ligament_courses.joins(:ligament_sections)
    all_dates = ligament_courses_and_sections.pluck(:date_complete, "ligament_sections.date_complete").flatten.compact.map{|elem| elem.to_date}.uniq

    arr_schedule = all_dates.map do |date|
      ligament_courses = self.ligament_courses.where('date_complete BETWEEN ? AND ?', date.beginning_of_day, date.end_of_day).uniq
      ligament_sections_ids = ligament_courses_and_sections
                             .where('ligament_sections.date_complete BETWEEN ? AND ?', date.beginning_of_day, date.end_of_day)
                             .pluck("ligament_sections.id").uniq

      {date: date, ligament_courses: ligament_courses.ids, ligament_sections: ligament_sections_ids}
    end
    arr_schedule
  end

  def notify_json(type=nil)
    {
      title: "Вас добавили в группу",
      body: "Поздравляем! Вы добавлены в группу «#{first_name}». Пожалуйста, проверьте, какие курсы назначены вашей группе для изучения.",
      timeClose: 0,
      linkGo: "/group?id=#{id}"
    }
  end

end
