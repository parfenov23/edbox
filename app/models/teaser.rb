class Teaser < ActiveRecord::Base
  belongs_to :attachment, dependent: :destroy
  belongs_to :course
  has_many :attachments, :as => :attachmentable, :dependent => :destroy

  def get_image(width=nil, height=nil)
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

  def create_img(image_path, width, height)
    attachment_img = MiniMagick::Image.open(image_path)
    if (width == nil) && (height == nil)
      Attachment.save_file('Teaser', id, attachment_img, 'full', nil, nil)
    else
      tumb = ResizeImage.course_image_resize(attachment_img, width, height)
      Attachment.save_file('Teaser', id, tumb, nil, width, height)
    end
  end

  def get_image_path(width=nil, height=nil)
    begin
      image = get_image(width=width, height=height)
      image.file.url
    rescue
      '/uploads/course_default_image.png'
    end
  end
end
