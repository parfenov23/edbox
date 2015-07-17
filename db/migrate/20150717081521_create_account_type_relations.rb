class CreateAccountTypeRelations < ActiveRecord::Migration
  def change
    create_table :account_type_relations do |t|
      t.string :modelable_type
      t.integer :modelable_id
      t.integer :account_type_id
    end
  end
end
