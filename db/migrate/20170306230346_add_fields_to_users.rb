class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :kid_name, :string
    add_column :users, :kid_class, :string
    add_column :users, :active, :boolean, default: false
  end
end
