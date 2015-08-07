class LigamentSection < ActiveRecord::Base
  belongs_to :ligament_course
  belongs_to :section
end
