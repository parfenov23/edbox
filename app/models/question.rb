class Question < ActiveRecord::Base
  belongs_to :test
  has_many :answers, :dependent => :destroy

  def transfer_to_json
    {
      id: id,
      title: title,
      answers: answers.map(&:transfer_to_json)
    }
  end
end
