class CreateLigamentSections < ActiveRecord::Migration
  def change
    create_table :ligament_sections do |t|
      t.integer :section_id
      t.datetime :date_complete
      t.integer :ligament_course_id

      t.timestamps
    end
  end
end
