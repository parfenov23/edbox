class AddTableToTag < ActiveRecord::Migration
  def change
    add_column :tags, :tagtable_type, :string
    add_column :tags, :tagtable_id, :integer
  end
end
