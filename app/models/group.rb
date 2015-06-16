class Group < ActiveRecord::Base
  has_one :company
  has_many :users

  def self.except_attr
    ["created_at", "updated_at"]
  end

end
