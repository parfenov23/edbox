class AddTitleToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :title, :text
    add_column :attachments, :duration, :integer, default: 0
  end
end
