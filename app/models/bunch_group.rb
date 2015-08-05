class BunchGroup < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  scope :in_study, -> { joins(user: [bunch_courses: [bunch_sections: [:bunch_attachments]]]).where({"bunch_attachments.complete" => true}).uniq }

  def self.build(user_id, group_id)
    user = User.find(user_id)
    bunch_groups = user.bunch_groups.where(group_id: group_id)
    if bunch_groups.count == 0
      result = new({user_id: user_id, group_id: group_id})
    else
      result = bunch_groups.last
    end
    result
  end

end
