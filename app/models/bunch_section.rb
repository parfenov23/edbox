class BunchSection < ActiveRecord::Base
  belongs_to :bunch_course
  belongs_to :section
  has_many :bunch_attachments
  scope :all_complete, -> { where({complete: true}) }

  def full_complete?(user_id)
    bunch_attachments_valid = bunch_attachments.where(complete: true).count >= bunch_attachments.count
    tests_valid = section.tests.joins(:test_results).where(test_results: {user_id: user_id}).count >= section.tests.count
    self.complete = (bunch_attachments_valid && tests_valid) ? true : false
    save
    bunch_course.full_complete?
    complete
  end

end
