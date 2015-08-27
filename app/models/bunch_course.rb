class BunchCourse < ActiveRecord::Base
  belongs_to :course
  belongs_to :group
  belongs_to :user
  belongs_to :ligament_course
  has_many :bunch_sections, dependent: :destroy
  has_many :notifications, :as => :notifytable, :dependent => :destroy

  scope :overdue, -> { where("date_complete < ?", Time.now.beginning_of_day) }
  scope :in_study, -> { includes(bunch_sections: [:bunch_attachments]).where({"bunch_attachments.complete" => true}).uniq }
  scope :find_bunch_sections, -> { BunchSection.where(bunch_course_id: ids) }
  scope :find_bunch_attachments, -> { BunchAttachment.where(bunch_section_id: find_bunch_sections.ids) }
  scope :uniq_by_course_id, -> { select(:course_id).distinct }

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

  def full_complete?
    sections = bunch_sections
    if sections.where(complete: true).count >= sections.count
      self.complete = true
      if user.corporate
        push_if_close
      end
    end
    self.save
    if self.complete == true
      BunchCourse.where(user_id: 4, course_id: 4, complete: false).each do |bunch_course|
        bunch_course.complete = true
        bunch_course.save
      end
    end
    complete
  end

  def push_if_close
    user.company.directors.each do |user|
      unless user.id != user_id
        user.create_notify(self, 'complete')
      end
    end
  end

  def self.build_to_group(course_id, group_id, date_complete, type, sections_hash)
    group = Group.find(group_id)
    bunch_groups = group.bunch_groups
    ligament_course = LigamentCourse.find_or_create_by({course_id: course_id, group_id: group_id})
    ligament_course.date_complete = Time.parse(date_complete).end_of_day if date_complete.present?
    ligament_course.save
    ligament_course.course.sections.not_empty.each do |section|
      ligament_section = LigamentSection.find_or_create_by({section_id: section.id, ligament_course_id: ligament_course.id})
      current_section = (sections_hash[section.id.to_s] rescue nil)
      ligament_section.date_complete = Time.parse(current_section).end_of_day if current_section.present?
      ligament_section.save
    end
    bunch_groups.each do |bunch_group|
      bunch_group.user.create_notify(ligament_course)
      build_to_user(course_id, bunch_group.user_id, group_id, date_complete, type, ligament_course.id, sections_hash)
    end
  end

  def self.build_to_user(course_id, user_id, group_id, date_complete, type, ligament_course_id=nil, sections_hash)
    date_complete = Time.parse(date_complete).end_of_day
    course = Course.find(course_id)
    sections = course.sections.not_empty
    user = User.find(user_id)
    bunch_course = user.bunch_courses.where({course_id: course_id, model_type: 'user'}).last
    if bunch_course.present?
      bunch_course.update({course_id: course_id, user_id: user.id,
                           group_id: group_id, model_type: type,
                           ligament_course_id: ligament_course_id})
    else
      bunch_course = user.bunch_courses.find_or_create_by({course_id: course_id, user_id: user.id,
                                                           group_id: group_id, model_type: type,
                                                           ligament_course_id: ligament_course_id})
    end
    bunch_course.date_complete = date_complete
    bunch_course.save
    sections.each do |section|
      current_section = (sections_hash[section.id.to_s] rescue nil)
      if type == "group"
        ligament_section = (bunch_course.group
                              .ligament_course.where(course_id: bunch_course.course_id)
                              .last.ligament_sections.where(section_id: section.id).last rescue nil)
        current_section = (ligament_section.date_complete rescue nil)
      end
      bunch_section = bunch_course.bunch_sections.find_or_create_by({section_id: section.id, bunch_course_id: bunch_course.id})
      bunch_section.date_complete = Time.parse(current_section).end_of_day if current_section.present?
      bunch_section.save
      section.attachments.not_empty.each do |attachment|
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

  def notify_json(type=nil)
    case type
      when "new"
        {
          title: "Добавлен новый курс в библиотеку.",
          body: "В вашей библиотеке, появился новый курс!",
          timeClose: 0,
          linkGo: "/courses"
        }
      when "complete"
        user_name = (user.full_name rescue "Нет имени")
        {
          title: "Пользователь закончил прохождение курса",
          body: "#{user_name} прошел курс “#{course.title}”",
          timeClose: 0,
          linkGo: "/courses"
        }
      when "overdue_course"
        {
          title: "Вы просрочили время прохождения.",
          body: "Вы не успели изучить курс “#{course.title}” в указанный срок",
          timeClose: 0,
          linkGo: "/courses"
        }
      when "close_overdue_course"
        {
          title: "Приближается время дедлайна курса",
          body: "Сегодня последний день для изучения курса “#{course.title}”",
          timeClose: 0,
          linkGo: "/courses"
        }
    end
  end


end
