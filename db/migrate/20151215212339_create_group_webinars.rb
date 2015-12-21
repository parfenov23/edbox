class CreateGroupWebinars < ActiveRecord::Migration
  def change
    create_table :group_webinars do |t|
      t.integer :webinar_id
      t.integer :group_id

      t.timestamps
    end
  end
end
