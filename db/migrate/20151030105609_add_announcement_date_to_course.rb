class AddAnnouncementDateToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :announcement_date, :datetime
  end
end
