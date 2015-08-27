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
  EXCEPT_ATTR = ["created_at", "updated_at", "file"]
  mount_uploader :file, AttachmentFileUploader
  belongs_to :attachmentable, :polymorphic => true
  before_save :set_file_type
  has_many :bunch_attachments
  has_one :test, :as => :testable, :dependent => :destroy
  scope :not_empty, -> { where.not(title: [nil, ""]) }

  default_scope { where(archive: false) } #unscoped

  def self.save_file(type, id, file, size=nil, width=nil, height=nil)
    class_name = type
    attachmentable = class_name.classify.constantize.find(id)
    attachment = attachmentable.attachments.build
    attachment.file = file
    attachment.size = size
    attachment.width = width
    attachment.height = height
    attachment.save
    if (attachment.file_type == VIDEO_FILE) && (attachment.size == nil)
      Thread.new do
        attachment.video_decode
        attachment.to_archive
      end
    end
    attachment
  end

  def class_type
    arr_types = ["text", "audio", "video", "test"]
    (arr_types.include? (file_type)) ? file_type : "text"
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

  def video_decode
    new_file_name = file.file.basename + '-' + Time.now.to_i.to_s + '-min.mp4'
    storage_path = Rails.root.to_s + '/tmp/video/'
    Dir.mkdir(storage_path) unless File.exists?(storage_path)
    new_file_path = storage_path + new_file_name
    VideoProc.decode(file.file, new_file_path)
    if File.exist?(new_file_path)
      new_file = File.open(new_file_path)
      attachment = Attachment.save_file(self.attachmentable_type, self.attachmentable_id, new_file, size='720p')
      attachment.title = self.title
      attachment.duration = self.duration
      attachment.save
      File.delete(new_file_path)
    end
  end

  def transfer_to_json
    as_json.merge({file_name: (file.file.original_filename rescue nil), file_size: (file.file.size rescue nil)})
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

  def find_type
    arr_text_type = ["description"]
    arr_text_type.include?(file_type) ? "text" : file_type
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
