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
      date_complete = (ligament_course.date_complete.to_s rescue (Time.now + 2.day).to_s )
      BunchCourse.build(course.id, id, date_complete, 'group', nil)
    end
  end

  # def schedule
  #   bunch_courses_and_sections = bunch_courses.joins(:bunch_sections)
  #   all_dates = bunch_courses_and_sections.pluck(:date_complete, "bunch_sections.date_complete").flatten.uniq.compact
  #   arr_schedule = all_dates.map do |date|
  #     bunch_courses = self.bunch_courses.where({date_complete: date}).uniq
  #     bunch_sections_ids = bunch_courses_and_sections
  #                            .where(bunch_sections: {date_complete: date})
  #                            .pluck("bunch_sections.id").uniq
  #
  #     {date: date, bunch_courses: bunch_courses.ids, bunch_sections: bunch_sections_ids}
  #   end
  #   arr_schedule
  # end

  def schedule
    ligament_courses_and_sections = ligament_courses.joins(:ligament_sections)
    all_dates = ligament_courses_and_sections.pluck(:date_complete, "ligament_sections.date_complete").flatten.uniq.compact
    arr_schedule = all_dates.map do |date|
      ligament_courses = self.ligament_courses.where({date_complete: date}).uniq
      ligament_sections_ids = ligament_courses_and_sections
                             .where(ligament_sections: {date_complete: date})
                             .pluck("ligament_sections.id").uniq

      {date: date, ligament_courses: ligament_courses.ids, ligament_sections: ligament_sections_ids}
    end
    arr_schedule
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
