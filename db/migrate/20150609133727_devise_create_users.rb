class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :email, null: false, default: ""
      t.string :password_digest, null: false, default: ""
      t.string :user_key, null: false, default: ""
      t.string :first_name, default: ""
      t.string :avatar, default: ""
      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
