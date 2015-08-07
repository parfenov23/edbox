class Course < ActiveRecord::Base
  has_many :sections, dependent: :destroy
  has_many :bunch_courses, dependent: :destroy
  has_many :favorite_courses, dependent: :destroy
  has_many :bunch_tags, dependent: :destroy
  has_many :ligament_courses, dependent: :destroy
  has_many :attachments, :as => :attachmentable, :dependent => :destroy
  has_many :notifications, :as => :notifytable, :dependent => :destroy
  belongs_to :user

  def create_all_img(image)
    attachment = Attachment.save_file('Course', id, image, 'full')
    attachment_wanted_sizes = [
      {width: 347, height: 192},
      {width: 920, height: 377},
      {width: 160, height: 128}
    ]
    attachment_wanted_sizes.each do |size|
      attachment_img = MiniMagick::Image.open(attachment.file.path)
      tumb = ResizeImage.course_image_resize(attachment_img, size[:width], size[:height])
      Attachment.save_file('Course', id, tumb, "#{size[:width]}x#{size[:height]}")
    end
  end

  def audiences
    bunch_courses.map(&:user_id).uniq
  end

  def push_if_create
    Thread.new do
      `rake user_notify:new_course[#{id}]`
    end
  end

  def get_image_path(size)
    attachment = attachments.where(size: size).last
    if attachment.present?
      attachment.file.url
    else
      case size
        when 'full'
          '/uploads/course_default_image_full.png'
        when '347x192'
          '/uploads/course_default_image_347×192.png'
        when '920x377'
          '/uploads/course_default_image_920×377.png'
        when '160×128'
          '/uploads/course_default_image_160×128.png'
        else
          '/uploads/course_default_image_full.png'
      end
    end
  end

  def notify_json(type=nil)
    case type
      when "new"
        {
          title: "Добавлен новый курс в библиотеку.",
          body: "В библиотеку добавлен новый курс 123",
          timeClose: 0,
          linkGo: "/courses"
        }
      when "remove"
        {
          title: "Директор удалил курс из программы",
          body: "Курс “#{title}” был удален из вашей группы",
          timeClose: 0,
          linkGo: "/courses"
        }
    end
  end

  def find_bunch_course(user_id, type='user', group_id=nil)
    bunch_courses.where({course_id: id, user_id: user_id, group_id: group_id, model_type: type}).last
  end

  def duration_time
    sections.joins(:attachments).sum("attachments.duration")
  end

  def full_duration
    duration
  end

  def clear_description
    ActionView::Base.full_sanitizer.sanitize(description).html_safe.to_s
      .gsub("&nbsp;", " ").gsub("&quot;", '"').gsub('&laquo;', '"').gsub('&raquo;', '"')
  end

  def images
      attachments.map do |att|
        arr_valid = ["full", "920x377"]
        if arr_valid.include?(att.size)
          att.as_json({except: Attachment::EXCEPT_ATTR, methods: :file_url})
        end
      end.compact!
  end

  def author
    user.as_json({except: User::EXCEPT_ATTR + ["user_key"]})
  end

  def transfer_to_json
    as_json({except: [:duration, :main_img, :description, :user_id], methods: [:clear_description, :images, :author], include: [
              {sections: {except: Section::EXCEPT_ATTR}}
            ]})
  end
end
