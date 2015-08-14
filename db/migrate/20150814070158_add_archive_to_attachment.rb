class AddArchiveToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :archive, :boolean, default: false
  end
end
