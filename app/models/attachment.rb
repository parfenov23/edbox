require 'carrierwave/orm/activerecord'
class Attachment < ActiveRecord::Base
  AUDIO_FILE = 'audio'
  IMAGE_FILE = 'image'
  VIDEO_FILE = 'video'
  OTHER_FILE = 'other'

  AVAILABLE_IMAGES = ['jpg', 'jpeg', 'gif', 'png']
  AVAILABLE_AUDIO = ['mp3','wav','m4a']
  AVAILABLE_VIDEO = ['mp4', 'webm', 'ogg', 'm4v', 'mov']
  AVAILABLE_OTHERS = ['pdf', 'txt', 'doc', 'docx', 'zip', 'ppt', 'pptx', 'xls', 'xlsx']

  mount_uploader :file, AttachmentFileUploader
  belongs_to :attachmentable, :polymorphic => true
  before_save :set_file_type


  def self.save_file(type, id, file, size=nil)
    class_name = type
    id = id
    attachmentable = class_name.classify.constantize.find(id)
    attachment = attachmentable.attachments.build
    attachment.file = file
    attachment.size  = size
    attachment.save
    attachment
  end

  private
  def set_file_type
    extension = file.file.extension.downcase
    type = OTHER_FILE

    if AVAILABLE_IMAGES.include?(extension)
      type = IMAGE_FILE
    elsif AVAILABLE_AUDIO.include?(extension)
      type = AUDIO_FILE
    elsif AVAILABLE_VIDEO.include?(extension)
      type = VIDEO_FILE
    end

    self.file_type = type
  end
end
