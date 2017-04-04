class AddPositionToCardCategory < ActiveRecord::Migration
  def change
    add_column :card_categories, :position, :integer
  end
end
