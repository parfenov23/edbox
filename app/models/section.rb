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

  def install_position
    positions_max = (course.sections.map(&:position).compact.max rescue 0)
    positions_max = positions_max.present? ? positions_max : 0
    self.position = positions_max + 1
    save
  end

  def validate
   attachments.present? ? ((!attachments.map(&:validate).include?(false)) rescue false) : false
  end

  def bunch_section(user_id)
    user = User.find(user_id)
    user.bunch_courses.joins(:bunch_sections).
      where({bunch_sections: {section_id: id}}).last.
      bunch_sections.where(section_id: id).last rescue nil
  end

end
