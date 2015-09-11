class AddBigbluebuttonRoomIdToWebinar < ActiveRecord::Migration
  def change
    add_column :webinars, :bigbluebutton_room_id, :integer
  end
end
