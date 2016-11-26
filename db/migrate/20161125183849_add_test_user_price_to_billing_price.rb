class AddTestUserPriceToBillingPrice < ActiveRecord::Migration
  def change
    add_column :billing_prices, :test_user_price, :float, default: 0
  end
end
