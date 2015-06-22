class Group < ActiveRecord::Base
  belongs_to :company
  has_many :users
  has_many :bunch_groups, :dependent => :destroy
  has_many :bunch_courses, :dependent => :destroy


  def self.except_attr
    ["created_at", "updated_at"]
  end

end
