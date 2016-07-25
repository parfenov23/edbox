class AddArchiveToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :archive, :boolean, default: false
  end
end
