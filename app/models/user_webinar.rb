class UserWebinar < ActiveRecord::Base
  belongs_to :users
  belongs_to :webinars
end
