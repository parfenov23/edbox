class CreateEmailNotifs < ActiveRecord::Migration
  def change
    create_table :email_notifs do |t|
      t.string :email

      t.timestamps
    end
  end
end
