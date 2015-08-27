class DropAccountType < ActiveRecord::Migration
  def up
    if table_exists? :account_type_relations
      drop_table :account_type_relations
    end
    if table_exists? :account_type
      drop_table :account_type
    end
  end
end
