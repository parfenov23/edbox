class CreateBunchTags < ActiveRecord::Migration
  def change
    create_table :bunch_tags do |t|
      t.integer :course_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
