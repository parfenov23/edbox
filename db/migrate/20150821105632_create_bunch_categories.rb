class CreateBunchCategories < ActiveRecord::Migration
  def change
    create_table :bunch_categories do |t|
      t.integer :course_id
      t.integer :category_id

      t.timestamps
    end
  end
end
