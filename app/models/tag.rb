class Tag < ActiveRecord::Base
  has_many :bunch_tags, :dependent => :destroy
end
