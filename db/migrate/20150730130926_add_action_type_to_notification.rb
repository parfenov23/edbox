class AddActionTypeToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :action_type, :string
  end
end
