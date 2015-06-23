class BunchCourse < ActiveRecord::Base
  belongs_to :course
  belongs_to :group

  def build

  end
end
