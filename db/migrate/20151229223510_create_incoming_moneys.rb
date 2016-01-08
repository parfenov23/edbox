class CreateIncomingMoneys < ActiveRecord::Migration
  def change
    create_table :incoming_moneys do |t|
      t.integer :user_id
      t.string :data

      t.timestamps
    end
  end
end
