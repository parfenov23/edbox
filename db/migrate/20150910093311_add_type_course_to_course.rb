class AddTypeCourseToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :type_course, :string, default: "course"
  end
end
