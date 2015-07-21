class CreateBunchAttachments < ActiveRecord::Migration
  def change
    create_table :bunch_attachments do |t|
      t.integer :attachment_id
      t.integer :bunch_section_id
      t.boolean :complete, default: false

      t.timestamps
    end
  end
end
