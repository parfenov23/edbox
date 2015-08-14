class AddDownloadToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :download, :boolean, default: false
  end
end
