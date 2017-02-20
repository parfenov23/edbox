class BunchCourse < ActiveRecord::Base
  belongs_to :course
  belongs_to :group
  belongs_to :user
  belongs_to :ligament_course
  has_many :bunch_sections, dependent: :destroy
  has_many :notifications, :as => :notifytable, :dependent => :destroy

  scope :overdue, -> { where("date_complete < ?", Time.now.beginning_of_day).where.not(complete: true, date_complete: nil) }
  scope :my, -> { where({model_type: "user"}) }
  scope :in_group, -> { where({model_type: "group"}) }
  scope :in_study, -> { includes(bunch_sections: [:bunch_attachments]).where({"bunch_attachments.complete" => true, complete: false}).uniq }
  scope :find_bunch_sections, -> { BunchSection.where(bunch_course_id: ids) }
  scope :find_bunch_attachments, -> { BunchAttachment.where(bunch_section_id: find_bunch_sections.ids) }
  scope :uniq_by_course_id, -> { select(:course_id).distinct }
  scope :all_type_courses, -> { all_type_courses_hash(all) }
  scope :uniq_by, -> (type) { uniq_by_type(all, type) }

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

  def self.uniq_by_type(models, type)
    arr = models.map { |model| model.method(type).call }.uniq
    arr_ids = arr.map { |one| models.where(type => one).last.id }
    models.where(id: arr_ids)
  end

  def self.all_type_courses_hash(models)
    arr_hashs = []
    # models = BunchCourse.where(id: bc.select(:course_id).uniq.ids)
    model_overdue = models.overdue.uniq_by(:course_id)
    arr_hashs += [{type: 'overdue', models: model_overdue, title: 'Просрочено'}] if model_overdue.present?

    model_study = models.in_study.uniq_by(:course_id)
    arr_hashs += [{type: 'in_study', models: model_study, title: 'На прохождении'}] if model_study.present?

    model_complete = models.where(complete: true).uniq_by(:course_id)
    arr_hashs += [{type: 'complete', models: model_complete, title: 'Завершенно'}] if model_complete.present?

    arr_hashs
  end

  def status
    progress = self.progress rescue 0
    bc_type = model_type == "user" rescue true
    bc_complete = complete rescue false
    hash = progress != 0 ? {v: "Пройдено на #{progress}%"} : (bc_type ? {v: 'Добавлен'} : {v: 'Назначен'})
    date = ApplicationController.helpers.time_current_day(date_complete) rescue 0
    hash = {v: "Пройти до #{date_complete.strftime("%d.%m.%y")}"} if date_complete.present?
    if overdue? && !course.online?
      count_over = ApplicationController.helpers.rus_case(date.abs, 'день', 'дня', 'дней')
      hash = {k: 'overdue', v: "Просрочен на #{count_over}"}
    end
    hash = {k: 'completed', v: 'Пройдено'} if bc_complete
    hash
  end

  def overdue?
    !date_complete.present? ? false : date_complete.end_of_day < Time.new.end_of_day
  end

  def transfer_to_json
    as_json({include: [
              {bunch_sections: {include: :bunch_attachments}}
            ]})
  end

  def progress
    all_sections = bunch_sections
    all_attachments = BunchAttachment.where(bunch_section_id: all_sections.pluck(:id))
    ((100.0 / (all_attachments.count.to_f / all_attachments.all_complete.count.to_f)).round) rescue 0
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
      ligament_section.date_complete = (Time.parse(current_section).end_of_day rescue nil) if current_section.present?
      ligament_section.save
    end
    bunch_groups.each do |bunch_group|
      bunch_group.user.create_notify(ligament_course)
      build_to_user(course_id, bunch_group.user_id, group_id, date_complete, type, ligament_course.id, sections_hash)
    end
  end

  def self.build_to_user(course_id, user_id, group_id, date_complete, type, ligament_course_id=nil, sections_hash)
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
    if group_id.blank?
      # HomeMailer.reg_course(course, user).deliver unless course.online?
    else
      HomeMailer.reg_course_director(course, user, bunch_course).deliver unless course.online?
    end
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

  def stat_status
    if !overdue?
      unless complete
        progress = self.progress rescue 0
        if progress == 0
          use_time = date_complete.strftime("%Y-%m-%d")
          "Назначен до #{use_time}" if model_type == "group"
        else
          "Пройдено #{progress}%"
        end
      else
        unless course.test.present?
          "Пройдено"
        else
          user_result = course.test.test_results.where(user_id: user_id).last
          user_result.present? ? " Тест пройден на #{user_result.percent}%" : "Тест"
        end
      end
    else
      date = ApplicationController.helpers.time_current_day(date_complete) rescue 0
      count_over = ApplicationController.helpers.rus_case(date.abs, 'день', 'дня', 'дней')
      "Просрочен на #{count_over}"
    end
  end

  def notify_json(type=nil)
    case type
      when "new"
        {
          title: "Добавлен новый курс в библиотеку.",
          body: "Обратите внимание! В библиотеку добавлен новый курс — «#{course.title}»",
          timeClose: 0,
          linkGo: "/courses"
        }
      when "complete"
        user_name = (user.full_name rescue "Нет имени")
        {
          title: "Пользователь закончил прохождение курса",
          body: "Ура! Ваш слушатель #{user_name} прошел курс «#{course.title}»!  Молодец!",
          timeClose: 0,
          linkGo: "/courses"
        }
      when "overdue_course"
        {
          title: "Вы просрочили время прохождения.",
          body: "Увы, к сожалению, вы не успели изучить курс «#{course.title}» в указанный вами для себя срок. Данные об этом сохранены в системе учета. Пожалуйста, не забывайте учиться вовремя! ",
          timeClose: 0,
          linkGo: "/courses"
        }
      when "close_overdue_course"
        {
          title: "Приближается время прохождения курса",
          body: "Обратите внимание! Сегодня — последний день для изучения курса «#{course.title}». Давайте не отставать от графика! Пожалуйста, успейте сегодня закончить обучение.",
          timeClose: 0,
          linkGo: "/courses"
        }
    end
  end


end
