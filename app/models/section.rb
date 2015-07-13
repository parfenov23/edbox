class Section < ActiveRecord::Base
  belongs_to :course
  has_many :attachments, :as => :attachmentable, :dependent => :destroy
  has_many :tests, :dependent => :destroy
end
