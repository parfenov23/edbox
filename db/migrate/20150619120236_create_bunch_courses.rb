class CreateBunchCourses < ActiveRecord::Migration
  def change
    create_table :bunch_courses do |t|
      t.integer :course_id
      t.integer :group_id
      t.datetime :date_start

      t.timestamps
    end
  end
end
