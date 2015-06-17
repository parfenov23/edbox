class CreateBunchGroups < ActiveRecord::Migration
  def change
    create_table :bunch_groups do |t|
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
  end
end
