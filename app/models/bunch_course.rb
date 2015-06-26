class BunchCourse < ActiveRecord::Base
  belongs_to :course
  belongs_to :group

  def self.build(course_id, group_id, date_start)
    group = Group.find(group_id)
    date_start = Time.parse(date_start).beginning_of_day
    bunch_groups = group.bunch_courses.where(course_id: course_id)
    if bunch_groups.count == 0
      result = new({course_id: course_id, group_id: group_id, date_start: date_start})
    else
      result = bunch_groups.last
      result.date_start = date_start
    end
    result
  end


end
