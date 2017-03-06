class AddTimeLineToAds < ActiveRecord::Migration
  def change
    add_column :ads, :time_line, :integer, default: 0
  end
end
