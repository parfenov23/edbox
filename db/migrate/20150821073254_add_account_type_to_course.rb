class AddAccountTypeToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :account_type_id, :integer
  end
end
