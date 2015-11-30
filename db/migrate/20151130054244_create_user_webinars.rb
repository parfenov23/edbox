class CreateUserWebinars < ActiveRecord::Migration
  def change
    create_table :user_webinars do |t|
      t.integer :user_id
      t.integer :webinar_id
      t.string :url

      t.timestamps
    end
  end
end
