class AddPublicToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :public, :boolean, default: false
  end
end
