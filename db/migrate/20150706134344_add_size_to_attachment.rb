class AddSizeToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :size, :string
  end
end
