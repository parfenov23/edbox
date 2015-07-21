class Course < ActiveRecord::Base
  has_many :sections, dependent: :destroy
  has_many :bunch_courses, dependent: :destroy
  has_many :favorite_courses, dependent: :destroy
  has_many :bunch_tags, dependent: :destroy
  has_many :ligament_courses, dependent: :destroy
  has_many :attachments, :as => :attachmentable, :dependent => :destroy
  belongs_to :user

  def create_all_img(image)
    attachment = Attachment.save_file('Course', id, image, 'full')
    attachment_img = MiniMagick::Image.open(attachment.file.path)
    tumb1 = ResizeImage.course_image_resize(attachment_img, 347, 192)
    Attachment.save_file('Course', id, tumb1, '347x192')
    tumb2 = ResizeImage.course_image_resize(attachment_img, 920, 377)
    Attachment.save_file('Course', id, tumb2, '920x377')
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
      else
        '/uploads/course_default_image_full.png'
      end
    end
  end
  def find_bunch_course(user_id, type='user', group_id=nil)
    bunch_courses.where({course_id: id, user_id: user_id, group_id: group_id, model_type: type}).last
  end

  def duration_time
    sections.joins(:attachments).sum("attachments.duration")
  end
end
