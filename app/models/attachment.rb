require 'carrierwave/orm/activerecord'
require 'video_proc'
class Attachment < ActiveRecord::Base
  AUDIO_FILE = 'audio'
  IMAGE_FILE = 'image'
  VIDEO_FILE = 'video'
  PDF_FILE = 'pdf'
  OTHER_FILE = 'other'

  AVAILABLE_IMAGES = ['jpg', 'jpeg', 'gif', 'png']
  AVAILABLE_AUDIO = ['mp3', 'wav', 'm4a']
  AVAILABLE_VIDEO = ['mp4', 'webm', 'ogg', 'm4v', 'mov']
  AVAILABLE_OTHERS = ['txt', 'doc', 'docx', 'zip', 'ppt', 'pptx', 'xls', 'xlsx']
  AVAILABLE_PDF = ['pdf']
  AVAILABLE_ALL = ['*']
  EXCEPT_ATTR = ["created_at", "updated_at", "file"]
  INCLUDE_TEST = {
    include: [test: {include: [questions: {include: :answers}]}],
    methods: [:clear_full_text]
  }

  mount_uploader :file, AttachmentFileUploader
  belongs_to :attachmentable, :polymorphic => true
  before_save :set_file_type
  # after_update :work_to_video
  has_many :bunch_attachments
  has_many :notes, :dependent => :destroy
  has_one :webinar, :dependent => :destroy
  has_many :attachments, :as => :attachmentable, :dependent => :destroy
  has_one :test, :as => :testable, :dependent => :destroy
  scope :not_empty, -> { where.not(title: [nil, ""]) }
  scope :webinars, -> { Webinar.where(attachment_id: ids) }

  default_scope { where(archive: false) } #unscoped
  default_scope { order("position ASC") } #unscoped

  def next
    return nil unless attachmentable_type == 'Section'
    attach = attachmentable.attachments.find_by(position: (position + 1))
    attach = attachmentable.course.sections.where(position: (attachmentable.position + 1)).attachments.first unless attach.present?
    attach
  end

  def link
    "/attachment?id=#{id}"
  end

  def clear_full_text
    ActionView::Base.full_sanitizer.sanitize(full_text.to_s.gsub("<p>", "").gsub("</p>", "\n")).html_safe.to_s
      .gsub("&nbsp;", " ").gsub("&quot;", '"').gsub('&laquo;', '"').gsub('&raquo;', '"')
  end

  def self.save_file(type, id, file, size=nil, width=nil, height=nil)
    class_name = type
    attachmentable = class_name.classify.constantize.find(id)
    attachment = attachmentable.attachments.build
    attachment.file = file
    attachment.size = size
    attachment.width = width
    attachment.height = height
    attachment.save
    # attachment.work_to_video
    attachment
  end

  def update_file(model, new_file)
    self.file = new_file
    self.attachmentable_type = model.class.to_s
    self.attachmentable_id = model.id
    save
    self
  end

  def validate
    valid_title = title.present? && description.present?
    valid_file = (!["test", "description", "webinar", "announcement", "video"].include?(file_type)) ? file.present? : valid_other
    validate_date = file_type == "webinar" ? (webinar.date_start.present? && webinar.duration.present?) : true
    valid_title && valid_file && validate_date
  end

  def valid_other
    case file_type
      when "test"
        test.present? ? test.validate : false
      when "description"
        full_text.present?
      when "webinar"
        true
      else
        true
    end
  end

  def file_name
    file.file.filename.split(".").first rescue nil
  end

  def install_position
    positions_max = (attachmentable.attachments.map(&:position).compact.max rescue 0)
    positions_max = positions_max.present? ? positions_max : 0
    self.position = positions_max + 1
    save
  end

  def class_type
    arr_types = ["text", "audio", "video", "test", "webinar"]
    (arr_types.include? (file_type)) ? file_type : "other"
  end

  def find_bunch_attachment(bunch_section_id)
    bunch_attachments.find_by_bunch_section_id(bunch_section_id)
  end

  def bunch_attachment(user_id)
    User.find(user_id).bunch_courses.find_bunch_attachments.where(attachment_id: id).last rescue nil
  end

  def full_duration
    duration.to_s + " минут"
  end

  def file_url
    file.url
  end

  def self.all_with_archive
    with_exclusive_scope { find(:all) }
  end

  def to_archive
    self.archive = true
    self.save
  end

  def render_video(size_p="720p")
    attachment = attachments.where({size: size_p}).last
    attachment.present? ? attachment : self
  end

  def work_to_video
    if (file_type == VIDEO_FILE) && (size == nil) && (!attachments.where({file_type: VIDEO_FILE, title: file_name}).present?)
      semaphore = Mutex.new
      Thread.new {
        ActiveRecord::Base.connection_pool.with_connection do
          semaphore.synchronize {
            attachments.destroy_all
            video_decode
          }
        end
      }
    end
  end

  def video_decode
    new_file_name = file.file.basename + '-' + Time.now.to_i.to_s + '-min.mp4'
    storage_path = Rails.root.to_s + '/tmp/video/'
    Dir.mkdir(storage_path) unless File.exists?(storage_path)
    new_file_path = storage_path + new_file_name
    VideoProc.decode(file.file, new_file_path)
    if File.exist?(new_file_path)
      new_file = File.open(new_file_path)
      attachment = Attachment.save_file("Attachment", id, new_file, size='720p')
      attachment.title = file_name
      attachment.save
      File.delete(new_file_path)
    end
  end

  def transfer_to_json
    as_json.merge({file_name: (file.file.original_filename rescue nil),
                   file_size: (file.file.size rescue nil), file_url: file.url})
  end

  def uploadType
    case file_type
      when "audio"
        'audio/*'
      when "video"
        'video/*'
      when "pdf"
        'application/pdf'
      when "other"
        ''
    end
  end

  def user_upload?
    file.file.original_filename.include?("mini_magick")
  end

  def find_type
    arr_text_type = ["description"]
    arr_text_type.include?(file_type) ? "text" : file_type
  end

  def announcement?
    file_type == 'announcement'
  end

  private

  def set_file_type
    if file.present?
      extension = file.file.extension.downcase
      type = OTHER_FILE

      if AVAILABLE_IMAGES.include?(extension)
        type = IMAGE_FILE
      elsif AVAILABLE_AUDIO.include?(extension)
        type = AUDIO_FILE
      elsif AVAILABLE_VIDEO.include?(extension)
        type = VIDEO_FILE
      elsif AVAILABLE_PDF.include?(extension)
        type = PDF_FILE
      end
      self.file_type = type
    end
  end

end
