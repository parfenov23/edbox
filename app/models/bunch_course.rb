class BunchCourse < ActiveRecord::Base
  belongs_to :course
  belongs_to :group
  belongs_to :user
  has_many :bunch_sections, dependent: :destroy

  default_scope { where(archive: false) } #unscoped

  def self.build(course_id, group_id, date_start, type, user_id=nil)
    case type
      when "group"
        build_to_group(course_id, group_id, date_start, type)
      when "user"
        build_to_user(course_id, user_id, nil, date_start, type)
    end
    true
  end

  def self.build_to_group(course_id, group_id, date_start, type)
    group = Group.find(group_id)
    bunch_groups = group.bunch_groups
    bunch_groups.each do |bunch_group|
      build_to_user(course_id, bunch_group.user_id, group_id, date_start, type)
    end
  end

  def self.build_to_user(course_id, user_id, group_id, date_start, type)
    date_start = Time.parse(date_start).beginning_of_day
    course = Course.find(course_id)
    sections = course.sections
    user = User.find(user_id)
    bunch_course = user.bunch_courses.find_or_create_by({course_id: course_id, user_id: user.id,
                                                          model_type: type, group_id: group_id})
    bunch_course.date_start = date_start
    bunch_course.save
    plus_day = 0
    sections.each do |section|
      bunch_section = bunch_course.bunch_sections.find_or_create_by({section_id: section.id, bunch_course_id: bunch_course.id})
      bunch_section.date_complete = date_start + plus_day.day
      plus_day += 1
      bunch_section.save
    end
  end

  def to_archive
    self.archive = true
    self.save
  end

  def self.closed
    with_exclusive_scope { find(:all) }
  end


end
