class AddVideoIdToWebinar < ActiveRecord::Migration
  def change
    add_column :webinars, :video_id, :integer
    add_column :webinars, :url, :string
  end
end
