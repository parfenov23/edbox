class BunchSection < ActiveRecord::Base
  belongs_to :bunch_course
  belongs_to :section
  has_many :bunch_attachments

  def full_complete?
    if bunch_attachments.where(complete: true).count == bunch_attachments.count
      self.complete = true
    end
    save
    complete
  end
end
