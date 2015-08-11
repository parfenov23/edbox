class AddTitleNameToAccountType < ActiveRecord::Migration
  def change
    add_column :account_types, :title, :string
    add_column :account_types, :info, :string
  end
end
