class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file
      t.string :file_type
      t.string :attachmentable_type
      t.integer :attachmentable_id

      t.timestamps
    end
  end
end
