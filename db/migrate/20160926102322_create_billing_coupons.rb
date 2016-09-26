class CreateBillingCoupons < ActiveRecord::Migration
  def change
    create_table :billing_coupons do |t|
      t.string :title
      t.float :price

      t.timestamps
    end
  end
end
