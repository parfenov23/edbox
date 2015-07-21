class AddTypeToBunchCourse < ActiveRecord::Migration
  def change
    add_column :bunch_courses, :model_type, :string
    add_column :bunch_courses, :user_id, :integer
    add_column :bunch_courses, :complete, :boolean, default: false
  end
end