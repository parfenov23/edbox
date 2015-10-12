class CreateAskQuestions < ActiveRecord::Migration
  def change
    create_table :ask_questions do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
