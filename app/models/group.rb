class Group < ActiveRecord::Base
  belongs_to :company
  has_many :users
  has_many :bunch_groups

  def self.except_attr
    ["created_at", "updated_at"]
  end

end
