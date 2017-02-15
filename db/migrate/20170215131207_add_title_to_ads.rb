class AddTitleToAds < ActiveRecord::Migration
  def change
    add_column :ads, :title, :string
    add_column :ads, :href, :string
    add_column :ads, :img, :string
    add_column :ads, :active, :boolean
  end
end
