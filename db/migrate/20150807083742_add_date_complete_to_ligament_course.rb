class AddDateCompleteToLigamentCourse < ActiveRecord::Migration
  def change
    add_column :ligament_courses, :date_complete, :datetime
  end
end
