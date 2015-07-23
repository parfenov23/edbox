class Test < ActiveRecord::Base
  belongs_to :section
  has_many :questions, :dependent => :destroy
  has_many :test_results, dependent: :destroy

  def transfer_to_json
    {
      id: id,
      title: title,
      questions: questions.map(&:transfer_to_json)
    }
  end

  def get_all_answer
    questions_id = questions.pluck(:id)
    Answer.where('question_id IN (' + questions_id.join(', ') + ')')
  end

  def get_correct_answers
    correct_answers = {}
    questions = self.questions
    questions.each do |question|
      answer = question.answers.where(right: true).pluck(:id)
      correct_answers.merge!({question.id => answer})
    end
    correct_answers
  end

  def self.hash_to_i(hash_old)
    hash_new = {}
    hash_old.each do |key, value|
      if value.class == Array
        hash_new.merge!({key.to_i => value.map(&:to_i)})
      else
        hash_new.merge!({key.to_i => value.to_i})
      end
    end
    hash_new
  end

  def get_result(answer)
    correct_answers = get_correct_answers.to_a
    user_answers = Test.hash_to_i(answer).to_a
    error_answer = correct_answers - user_answers

    question_count = correct_answers.count
    right_count = correct_answers.count - error_answer.count
    question_count = 1 if question_count == 0
    result = ((right_count/question_count.to_f)*100).round
    {right_answers: right_count, all_questions: question_count, result: result}
  end

  def result(user_id, answer)
    if answer.present?
      user_result = get_result(answer)
      result = TestResult.new({
                                user_id: user_id,
                                test_id: id,
                                right_answers: user_result[:right_answers],
                                all_questions: user_result[:all_questions],
                                result: user_result[:result]})
      if result.save
        result
      else
        false
      end
    end
  end
end
