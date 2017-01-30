class AddJidToWebinar < ActiveRecord::Migration
  def change
    add_column :webinars, :jid, :string
  end
end
