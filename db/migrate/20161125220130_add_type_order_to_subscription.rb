class AddTypeOrderToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :type_order, :string
  end
end
