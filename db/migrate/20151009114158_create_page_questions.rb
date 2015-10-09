class CreatePageQuestions < ActiveRecord::Migration
  def change
    create_table :page_questions do |t|
      t.string :title
      t.text :content
      t.integer :ask_question_id

      t.timestamps
    end
  end
end
