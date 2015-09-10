class CreateWebinars < ActiveRecord::Migration
  def change
    create_table :webinars do |t|
      t.datetime :date_start
      t.integer :duration
      t.integer :attachment_id

      t.timestamps
    end
  end
end
