class CreateFooterChildren < ActiveRecord::Migration
  def change
    create_table :footer_children do |t|
      t.string :title
      t.string :href
      t.integer :footer_parent_id

      t.timestamps
    end
  end
end
