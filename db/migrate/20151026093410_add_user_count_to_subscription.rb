class AddUserCountToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :user_count, :integer, default: 0
  end
end
