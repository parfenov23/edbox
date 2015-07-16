class LigamentCourse < ActiveRecord::Base
  has_many :bunch_courses, dependent: :destroy
  belongs_to :course
end
