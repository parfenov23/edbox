class Course < ActiveRecord::Base
  has_many :sections, :dependent => :destroy
  has_many :bunch_courses, :dependent => :destroy
end
