class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :first_name
      t.integer :company_id

      t.timestamps
    end
  end
end
