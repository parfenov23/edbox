class ChangeColumnSumToSubscriptions < ActiveRecord::Migration
  def change
    change_column :subscriptions, :sum, :float, default: 0
  end
end
