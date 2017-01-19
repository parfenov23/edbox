class AddDateEntryToUserWebinar < ActiveRecord::Migration
  def change
    add_column :user_webinars, :date_entry, :datetime
  end
end
