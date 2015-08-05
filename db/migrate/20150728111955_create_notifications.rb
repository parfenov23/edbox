class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.string :notifytable_type
      t.integer :notifytable_id
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
