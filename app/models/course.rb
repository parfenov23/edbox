class Course < ActiveRecord::Base
  has_many :sections, dependent: :destroy
  has_many :bunch_courses, dependent: :destroy
  has_many :favorite_courses, dependent: :destroy
  belongs_to :user
end
