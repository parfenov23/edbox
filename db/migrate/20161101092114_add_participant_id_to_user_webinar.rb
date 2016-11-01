class AddParticipantIdToUserWebinar < ActiveRecord::Migration
  def change
    add_column :user_webinars, :participant_id, :integer
  end
end
