class AddDurationToTest < ActiveRecord::Migration
  def change
    add_column :tests, :duration, :integer
  end
end
