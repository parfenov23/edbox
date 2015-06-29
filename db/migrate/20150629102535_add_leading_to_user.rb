class AddLeadingToUser < ActiveRecord::Migration
  def change
    add_column :users, :leading, :boolean, default: false
  end
end
