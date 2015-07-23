class Section < ActiveRecord::Base
  belongs_to :course
  has_many :attachments, :as => :attachmentable, :dependent => :destroy
  has_many :tests, :dependent => :destroy

  def all_formats
    attachments.map{|at| at.type}.uniq
  end

  def bunch_section(user_id)
    user = User.find(user_id)
    user.bunch_courses.joins(:bunch_sections).
      where({bunch_sections: {section_id: id}}).last.
      bunch_sections.where(section_id: id).last rescue nil
  end

end
