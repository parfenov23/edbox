require 'resize_image'
class Course < ActiveRecord::Base
  has_many :sections, dependent: :destroy
  has_many :bunch_courses, dependent: :destroy
  has_many :favorite_courses, dependent: :destroy
  has_many :bunch_tags, dependent: :destroy
  has_many :bunch_categories, dependent: :destroy
  has_many :ligament_courses, dependent: :destroy
  has_many :attachments, :as => :attachmentable, :dependent => :destroy
  has_many :notifications, :as => :notifytable, :dependent => :destroy
  has_many :ligament_leads, :dependent => :destroy
  belongs_to :user
  has_one :test, :as => :testable, :dependent => :destroy
  scope :publication, -> { where(public: true) }
  scope :materials, -> { where(type_course: "material") }
  scope :webinars, -> { where(type_course: "online") }
  default_scope { order("created_at DESC") }
  USERID_TOJSON = nil

  def create_img(image_path, width, height)
    attachment_img = MiniMagick::Image.open(image_path)
    if (width == nil) && (height == nil)
      Attachment.save_file('Course', id, attachment_img, 'full', nil, nil)
    else
      tumb = ResizeImage.course_image_resize(attachment_img, width, height)
      Attachment.save_file('Course', id, tumb, nil, width, height)
    end
  end

  def audiences
    bunch_courses.map(&:user_id).uniq.count
  end

  def validate
    {description: description_validate, program: program_validate}
  end

  def description_validate
    title.present? && description.present? && bunch_categories.present?
  end

  def program_validate
    sections_validate = (!sections.where(title: [nil, ""]).present?) ? !sections.map(&:validate).include?(false) : false
    test_validate = test.present? ? test.validate : true
    sections_validate && test_validate
  end

  # def get_type
  #   account_type_relation.account_type rescue nil
  # end

  def push_if_create
    Thread.new do
      `rake user_notify:new_course[#{id}]`
    end
  end

  def get_image(width=nil, height=nil)
    if type_course != "material"
      attachment = attachments.where(file_type: 'image', width: width, height: height).last
      if attachment.present?
        image = attachment
      else
        attachment_full = attachments.where(file_type: 'image', size: 'full').last
        if attachment_full.present?
          image = create_img(attachment_full.file.path, width, height)
        else
          image = create_img(Rails.root.join('public/uploads/course_default_image.png').to_s, width, height)
        end
      end
      image
    end
  end

  def webinar_deadline
    sections.attachments.webinars.order("date_start ASC").last.date_start.end_of_day
  end

  def material?
    type_course == "material"
  end

  def online?
    type_course == "online"
  end

  def leading?(user_id)
    leadings_ids = leadings.map { |l| l["id"] }
    leadings_ids.include?(user_id)
  end

  def get_image_path(width=nil, height=nil)
    begin
      image = get_image(width=width, height=height)
      image.file.url
    rescue
      '/uploads/course_default_image.png'
    end
  end

  def notify_json(type=nil)
    case type
      when "new"
        {
          title: "Добавлен новый курс в библиотеку.",
          body: "Обратите внимание! В библиотеку добавлен новый курс — «#{title}». Возможно, стоит назначить этот курс кому-либо из ваших групп слушателей? ",
          timeClose: 0,
          linkGo: "/course_description?id=#{id}"
        }
      when "remove"
        {
          title: "Директор удалил курс из программы",
          body: "Увы, курс «#{title}», назначенный вашей группе, был удален руководителем группы. Сожалеем об этом. ",
          timeClose: 0,
          linkGo: "/courses"
        }
    end
  end

  def find_bunch_course(user_id, type='user', group_id=nil)
    hash_expression = {course_id: id, user_id: user_id, group_id: group_id, model_type: type}.compact
    bunch_courses.where(hash_expression).last
  end


  def duration_time
    sections.joins(:attachments).sum("attachments.duration")
  end

  def full_duration
    duration
  end

  def clear_description
    ActionView::Base.full_sanitizer.sanitize(description.to_s.gsub("<p>", "").gsub("</p>", "\n")).html_safe.to_s
      .gsub("&nbsp;", " ").gsub("&quot;", '"').gsub('&laquo;', '"').gsub('&raquo;', '"').gsub('&mdash;', '—')
      .gsub('&gt;', '>')
  end

  def images
    attachments.map do |att|
      arr_valid = ["full", "920x377"]
      if arr_valid.include?(att.size)
        att.as_json({except: Attachment::EXCEPT_ATTR, methods: :file_url})
      end
    end.compact!
  end

  def teaser_image
    if type_course != "meterial"
      image = get_image(1000, 562)
      image.as_json({except: Attachment::EXCEPT_ATTR, methods: :file_url})
    end
  end

  def creator
    user.as_json({except: User::EXCEPT_ATTR + ["user_key", "avatar"]})
  end

  def leadings
    ligament_leads.map { |ll| ll.user.as_json({except: User::EXCEPT_ATTR + ["user_key"]}) }
  end

  def teaser_video
    attachments.where(file_type: "video").last.file.url rescue nil
  end

  def assigned?(user_id)
    bunch_courses.where(user_id: user_id).present?
  end


  def ligament_groups(user_id = nil)
    if user_id.present?
      user = User.find(user_id)
      ids = user.all_groups.ids
      lc = ligament_courses.where(group_id: ids).map(&:transfer_to_json)
    else
      lc = ligament_courses.map(&:transfer_to_json)
    end
    lc
  end

  def transfer_to_json(user_id = nil)
    ligament_groups = self.ligament_groups(user_id)
    result = as_json({except: [:duration, :main_img, :description, :user_id, :account_type_id],
                      methods: [:clear_description, :teaser_image, :teaser_video, :leadings, :audiences, :duration_time],
                      include:
                        [{sections: {except: Section::EXCEPT_ATTR,
                                     include: [{attachments: Attachment::INCLUDE_TEST}]}
                         },
                         {test: {include: [questions: {include: :answers}]}}
                        ]
                     })
    result["assigned"] = assigned?(user_id)
    result["categories"] = bunch_categories.map{|bc| {id: bc.category_id, name: bc.category.title} }
    result["tags"] = bunch_tags.map{|bt| {id: bt.tag_id, name: bt.tag.title} }
    result["ligament_groups"] = ligament_groups
    result
  end

  def transfer_to_json_mini
    as_json({except: [:duration, :main_img, :description, :user_id],
             methods: [:clear_description, :teaser_image, :leadings, :duration_time]})
  end
end
