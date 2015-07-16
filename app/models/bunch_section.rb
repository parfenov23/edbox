class BunchSection < ActiveRecord::Base
  belongs_to :bunch_course
  belongs_to :section
end
