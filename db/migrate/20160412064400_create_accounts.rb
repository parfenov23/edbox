class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :user_id
      t.string :token
      t.string :card_first_six
      t.string :card_last_four
      t.string :card_type
      t.string :issuer_bank_country

      t.timestamps
    end
  end
end
