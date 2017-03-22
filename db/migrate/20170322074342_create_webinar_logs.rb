class CreateWebinarLogs < ActiveRecord::Migration
  def change
    create_table :webinar_logs do |t|
      t.string :type_send
      t.string :params
      t.string :path
      t.text :response

      t.timestamps
    end
  end
end
