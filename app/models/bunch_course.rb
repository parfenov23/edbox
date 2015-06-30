class BunchCourse < ActiveRecord::Base
  belongs_to :course
  belongs_to :group
  default_scope {where(archive: false)} #unscoped

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

  def to_archive
    self.archive = true
    self.save
  end

  def self.closed
    with_exclusive_scope { find(:all) }
  end


end
