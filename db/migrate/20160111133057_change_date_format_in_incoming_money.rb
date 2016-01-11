class ChangeDateFormatInIncomingMoney < ActiveRecord::Migration
  def change
  	change_column :incoming_moneys, :data, :text
  end
end
