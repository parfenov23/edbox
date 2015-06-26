class AddArchiveToBunchCourse < ActiveRecord::Migration
  def change
    add_column :bunch_courses, :archive, :boolean, default: false
  end
end
