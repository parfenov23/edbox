class AddNoteToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :note, :text
  end
end
