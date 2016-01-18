class TestResult < ActiveRecord::Base
  belongs_to :test
  belongs_to :user

  def percent
    (100.to_f/all_questions.to_f * right_answers.to_f).ceil
  end
end
