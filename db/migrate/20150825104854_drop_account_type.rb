class DropAccountType < ActiveRecord::Migration
  def up
    begin
      drop_table :account_type_relations
      drop_table :account_type
    rescue
      nil
    end
  end
end
