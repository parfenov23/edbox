class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.integer :section_id
      t.string :title
    end
  end
end
