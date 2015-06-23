class Group < ActiveRecord::Base
  belongs_to :company
  has_many :users
  has_many :bunch_groups, :dependent => :destroy
  has_many :bunch_courses, :dependent => :destroy
  EXCEPT_ATTR = ["created_at", "updated_at"]

  def transfer_to_json
    result = as_json(:except => EXCEPT_ATTR)
    result
  end

end
