class Question < ActiveRecord::Base
  belongs_to :test
  has_many :answers, :dependent => :destroy
  scope :find_answers, -> { Answer.where(question_id: ids) }
  default_scope { order("id ASC") }

  def build_default
    2.times do
      answers.new.save
    end
  end

  def validate
    valid = false
    if title.present? && answers.count >= 2 && answers.where(right: true).count >= 1
      valid = true
    end
    valid
  end

  def transfer_to_json
    as_json.merge(questions: answers.map(&:transfer_to_json))
  end
end
