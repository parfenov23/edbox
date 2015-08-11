class AddDateToAccountTypeRelation < ActiveRecord::Migration
  def change
    add_column :account_type_relations, :date, :datetime
  end
end
