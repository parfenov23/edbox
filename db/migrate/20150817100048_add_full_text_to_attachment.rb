class AddFullTextToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :full_text, :text
  end
end
