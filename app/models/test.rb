class Test < ActiveRecord::Base
  belongs_to :section
  has_many :questions, :dependent => :destroy
  has_many :test_results, dependent: :destroy

  def get_all_answer
    questions_id = questions.pluck(:id)
    Answer.where('question_id IN (' + questions_id.join(', ') + ')')
  end

  def get_result(answer)
    correct_answer_ids = get_all_answer.where(right: true).pluck(:id)
    max_point = correct_answer_ids.count
    user_answer_ids = answer.values.map(&:to_i)
    error_point = (correct_answer_ids - user_answer_ids).count
    user_point = max_point - error_point
    user_point = 0 if user_point < 0
    user_mark = ((user_point/max_point.to_f)*100).round
  end

  def result(user_id, answer)
    user_result = get_result(answer)
    TestResult.new(user_id: user_id, test_id: id, result: user_result).save
  end
end
