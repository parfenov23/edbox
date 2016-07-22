class AddOggToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :og, :text
  end
end
