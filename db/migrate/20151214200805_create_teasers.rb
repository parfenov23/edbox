class CreateTeasers < ActiveRecord::Migration
  def change
    create_table :teasers do |t|
      t.integer :attachment_id
      t.integer :course_id

      t.timestamps
    end
  end
end
