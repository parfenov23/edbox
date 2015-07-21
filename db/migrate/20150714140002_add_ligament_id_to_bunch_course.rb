class AddLigamentIdToBunchCourse < ActiveRecord::Migration
  def change
    add_column :bunch_courses, :ligament_course_id, :integer
  end
end
