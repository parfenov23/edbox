class AddSessionToWebinar < ActiveRecord::Migration
  def change
    add_column :webinars, :session, :integer
  end
end
