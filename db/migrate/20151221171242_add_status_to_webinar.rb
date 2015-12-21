class AddStatusToWebinar < ActiveRecord::Migration
  def change
    add_column :webinars, :status, :string
  end
end
