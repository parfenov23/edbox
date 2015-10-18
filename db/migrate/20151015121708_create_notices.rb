class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :email
      t.integer :course_id

      t.timestamps
    end
  end
end