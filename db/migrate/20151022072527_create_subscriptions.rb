class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.datetime :date_from
      t.datetime :date_to
      t.integer :subscriptiontable_id
      t.string :subscriptiontable_type
      t.float :sum
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
