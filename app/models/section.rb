class Section < ActiveRecord::Base
  belongs_to :course
  has_many :attachments, :as => :attachmentable, :dependent => :destroy
  has_many :tests, :dependent => :destroy
  scope :not_empty, -> { where.not(title: [nil, ""]) }
  EXCEPT_ATTR = ["update_at"]

  def all_formats
    attachments.map { |at| at.type }.uniq
  end

  def transfer_to_json
    as_json
  end

  def bunch_section(user_id)
    user = User.find(user_id)
    user.bunch_courses.joins(:bunch_sections).
      where({bunch_sections: {section_id: id}}).last.
      bunch_sections.where(section_id: id).last rescue nil
  end

end
