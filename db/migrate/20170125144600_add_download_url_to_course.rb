class AddDownloadUrlToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :download_url, :string
  end
end
