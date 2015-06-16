class AddCompanyIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :company_id, :integer
    add_column :users, :director, :boolean, default: false
    add_column :users, :corporate, :boolean, default: false
  end
end
