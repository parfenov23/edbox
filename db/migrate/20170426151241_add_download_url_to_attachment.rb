class AddDownloadUrlToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :download_url, :text
  end
end
