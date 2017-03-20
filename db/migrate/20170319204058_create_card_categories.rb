class CreateCardCategories < ActiveRecord::Migration
  def change
    create_table :card_categories do |t|
      t.string :title
      t.string :icon

      t.timestamps
    end
  end
end
