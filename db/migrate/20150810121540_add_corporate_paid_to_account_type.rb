class AddCorporatePaidToAccountType < ActiveRecord::Migration
  def change
    add_column :account_types, :corporate, :boolean, default: false
    add_column :account_types, :paid, :boolean, default: false
  end
end
