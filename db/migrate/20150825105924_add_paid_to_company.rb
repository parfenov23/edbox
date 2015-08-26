class AddPaidToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :paid, :boolean, default: false
  end
end
