class FavoriteCourse < ActiveRecord::Base
  belongs_to :course
  belongs_to :user

  def transfer_to_json
    as_json
  end
end
