class BunchCourse < ActiveRecord::Base
  belongs_to :course
  belongs_to :group
  belongs_to :user
  belongs_to :ligament_course
  has_many :bunch_sections, dependent: :destroy

  scope :overdue, -> { where("date_complete < ?", Time.now.beginning_of_day) }
  scope :in_study, -> { includes(bunch_sections: [:bunch_attachments]).where({"bunch_attachments.complete" => true}).uniq }

  default_scope { where(archive: false) } #unscoped

  # default_scope { order("created_at DESC") } #unscoped

  def self.build(course_id, group_id, date_complete, type, user_id=nil, sections_hash={})
    case type
      when "group"
        build_to_group(course_id, group_id, date_complete, type, sections_hash)
      when "user"
        build_to_user(course_id, user_id, nil, date_complete, type, nil, sections_hash)
    end
    true
  end

  def self.build_to_group(course_id, group_id, date_complete, type, sections_hash)
    group = Group.find(group_id)
    bunch_groups = group.bunch_groups
    ligament_course = LigamentCourse.find_or_create_by({course_id: course_id, group_id: group_id})
    bunch_groups.each do |bunch_group|
      build_to_user(course_id, bunch_group.user_id, group_id, date_complete, type, ligament_course.id, sections_hash)
    end
  end

  def self.build_to_user(course_id, user_id, group_id, date_complete, type, ligament_course_id=nil, sections_hash)
    date_complete = Time.parse(date_complete).end_of_day
    course = Course.find(course_id)
    sections = course.sections
    user = User.find(user_id)
    bunch_course = user.bunch_courses.find_or_create_by({course_id: course_id, user_id: user.id,
                                                         model_type: type, group_id: group_id,
                                                         ligament_course_id: ligament_course_id})
    bunch_course.date_complete = date_complete
    bunch_course.save
    sections.each do |section|
      current_section = (sections_hash[section.id.to_s] rescue nil)
      bunch_section = bunch_course.bunch_sections.find_or_create_by({section_id: section.id, bunch_course_id: bunch_course.id})
      bunch_section.date_complete = Time.parse(current_section) if current_section.present?
      bunch_section.save
      section.attachments.each do |attachment|
        BunchAttachment.find_or_create_by({attachment_id: attachment.id, bunch_section_id: bunch_section.id})
      end
    end
  end

  def to_archive
    self.archive = true
    self.save
  end

  def full_duration
    "32 часа"
  end

  def self.closed
    with_exclusive_scope { find(:all) }
  end


end
