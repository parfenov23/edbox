class CreateFavoriteCourses < ActiveRecord::Migration
  def change
    create_table :favorite_courses do |t|
      t.integer :course_id
      t.integer :user_id

      t.timestamps
    end
  end
end
