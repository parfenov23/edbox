class CreateBunchSections < ActiveRecord::Migration
  def change
    create_table :bunch_sections do |t|
      t.datetime :date_complete
      t.boolean :complete, default: false
      t.integer :section_id
      t.integer :bunch_course_id

      t.timestamps
    end
  end
end
