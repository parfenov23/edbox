class Test < ActiveRecord::Base
  require 'resize_image'

  belongs_to :section
  has_many :questions, :dependent => :destroy
  has_many :test_results, dependent: :destroy
  belongs_to :testable, :polymorphic => true
  default_scope { order("id ASC") }

  def transfer_to_json
    as_json.merge(questions: questions.map(&:transfer_to_json))
  end

  def get_all_answer
    questions_id = questions.pluck(:id)
    Answer.where('question_id IN (' + questions_id.join(', ') + ')')
  end

  def validate
    !questions.map(&:validate).include?(false)
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

  def build_default
    new_question = questions.new
    2.times do
      new_question.answers.new.save
    end
    new_question.save
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
      result = self.test_results.new({
                                       user_id: user_id,
                                       right_answers: user_result[:right_answers],
                                       all_questions: user_result[:all_questions],
                                       result: user_result[:result]})
      if testable_type == "Attachment"
        bunch_attachment = testable.bunch_attachment(user_id)
        if bunch_attachment.present?
          bunch_attachment.complete = true
          bunch_attachment.save
          bunch_attachment.bunch_section.full_complete?(user_id)
        end
      end
      result.save ? result : false
    end
  end

  def certificate(user)
    root_path = "#{Rails.root}/public"
    file_path = "/system/tests_cert/#{id}_#{user.id}.png"
    full_path = root_path + file_path
    dir = File.dirname(full_path)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    unless File.file?(full_path)
      FileUtils.cp("#{Rails.root}/public/uploads/cert.png", full_path)
      test_model = testable
      ResizeImage.add_text(full_path, user.full_name, 535, 660)
      ResizeImage.add_text(full_path, test_model.title, 535, 820)
      ResizeImage.add_text(full_path, (test_model.ligament_leads.first.user.full_name rescue 'Нет'), 952, 1038, 24)
    end
    file_path
  end
end
