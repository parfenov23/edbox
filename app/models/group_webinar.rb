class GroupWebinar < ActiveRecord::Base
  belongs_to :webinar
  belongs_to :group
end
