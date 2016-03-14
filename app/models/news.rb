class News < ActiveRecord::Base

  def read?(user)
    if user.present?
      users_id.include?(user.id)
    else
      true
    end
  end
end
