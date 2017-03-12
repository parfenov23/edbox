class CreateTariffs < ActiveRecord::Migration
  def change
    create_table :tariffs do |t|
      t.string :title
      t.string :type_tariff
      t.boolean :active
      t.integer :price

      t.timestamps
    end
  end
end
