class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :type_ad
      t.text :content

      t.timestamps
    end
  end
end
