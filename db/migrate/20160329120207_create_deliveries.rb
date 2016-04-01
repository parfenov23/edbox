class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.string :title
      t.text :description
      t.integer :users_id, array: true, default: []

      t.timestamps
    end
  end
end
