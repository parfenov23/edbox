class AddHelpToUser < ActiveRecord::Migration
  def change
    add_column :users, :help, :boolean, default: true
  end
end
