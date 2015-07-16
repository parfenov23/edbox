class CreateTestResult < ActiveRecord::Migration
  def change
    create_table :test_results do |t|
      t.integer :user_id
      t.integer :test_id
      t.integer :result
    end
  end
end
