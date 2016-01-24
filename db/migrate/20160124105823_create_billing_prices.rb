class CreateBillingPrices < ActiveRecord::Migration
  def change
    create_table :billing_prices do |t|
      t.float :company_price, default: 1
      t.float :user_price, default: 1
      t.float :company_user_price, default: 1

      t.timestamps
    end
  end
end
