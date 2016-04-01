class Delivery < ActiveRecord::Base
  def users
    User.where(id: users_id)
  end

  def description_to_text(user)
    description.gsub('${user_name}', user.full_name)
  end
end
