class ChangeTableUser < ActiveRecord::Migration
  def change
    change_column_default :users, :job, nil
  end
end
