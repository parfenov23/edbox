class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :user_id
      t.integer :attachment_id
      t.text :text, null: false, default: ''
      t.timestamps
    end
  end
end
