class CreateLigamentCourses < ActiveRecord::Migration
  def change
    create_table :ligament_courses do |t|
      t.integer :course_id
      t.integer :group_id
      t.boolean :process, default: false

      t.timestamps
    end
  end
end
