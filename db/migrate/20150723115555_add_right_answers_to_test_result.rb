class AddRightAnswersToTestResult < ActiveRecord::Migration
  def change
    add_column :test_results, :all_questions, :integer
    add_column :test_results, :right_answers, :integer
  end
end
