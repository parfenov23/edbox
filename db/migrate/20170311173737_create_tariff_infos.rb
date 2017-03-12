class CreateTariffInfos < ActiveRecord::Migration
  def change
    create_table :tariff_infos do |t|
      t.string :title
      t.string :array_ids

      t.timestamps
    end
  end
end
