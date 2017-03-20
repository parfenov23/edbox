class CreateCardItems < ActiveRecord::Migration
  def change
    create_table :card_items do |t|
      t.string :title
      t.text :description
      t.integer :card_id
      t.integer :card_category_id

      t.timestamps
    end
  end
end
