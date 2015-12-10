class DropBbb < ActiveRecord::Migration
  def change
    drop_table :bigbluebutton_meetings  if ActiveRecord::Base.connection.table_exists? :bigbluebutton_meetings
    drop_table :bigbluebutton_playback_formats  if ActiveRecord::Base.connection.table_exists? :bigbluebutton_playback_formats
    drop_table :bigbluebutton_playback_types  if ActiveRecord::Base.connection.table_exists? :bigbluebutton_playback_types
    drop_table :bigbluebutton_metadata  if ActiveRecord::Base.connection.table_exists? :bigbluebutton_metadata
    drop_table :bigbluebutton_recordings  if ActiveRecord::Base.connection.table_exists? :bigbluebutton_recordings
    drop_table :bigbluebutton_rooms  if ActiveRecord::Base.connection.table_exists? :bigbluebutton_rooms
    drop_table :bigbluebutton_rooms_options  if ActiveRecord::Base.connection.table_exists? :bigbluebutton_rooms_options
    drop_table :bigbluebutton_servers  if ActiveRecord::Base.connection.table_exists? :bigbluebutton_servers
    drop_table :bigbluebutton_server_configs  if ActiveRecord::Base.connection.table_exists? :bigbluebutton_server_configs
  end
end
