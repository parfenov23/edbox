class AddContenterToUser < ActiveRecord::Migration
  def change
    add_column :users, :contenter, :boolean, default: false
  end
end
