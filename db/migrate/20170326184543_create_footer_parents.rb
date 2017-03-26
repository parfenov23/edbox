class CreateFooterParents < ActiveRecord::Migration
  def change
    create_table :footer_parents do |t|
      t.string :title

      t.timestamps
    end
  end
end
