class CreateOggs < ActiveRecord::Migration
  def change
    create_table :oggs do |t|
      t.string :title
      t.text :description
      t.string :image
      t.string :oggtable_type
      t.integer :oggtable_id

      t.timestamps
    end
  end
end
