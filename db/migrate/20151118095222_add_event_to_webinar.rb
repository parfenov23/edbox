class AddEventToWebinar < ActiveRecord::Migration
  def change
    add_column :webinars, :event, :integer
    remove_column :webinars, :bigbluebutton_room_id
  end
end
