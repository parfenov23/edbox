class Question < ActiveRecord::Base
  belongs_to :test
  has_many :answers, :dependent => :destroy
  default_scope { order("id ASC") }

  def build_default
    2.times do
      answers.new.save
    end
  end

  def transfer_to_json
    as_json.merge(questions: answers.map(&:transfer_to_json))
  end
end
