class AddDateCompleteToBunchCourse < ActiveRecord::Migration
  def change
    add_column :bunch_courses, :date_complete, :datetime
  end
end
