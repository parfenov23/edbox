class AddDurationToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :duration, :integer
  end
end
