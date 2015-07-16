class Answer < ActiveRecord::Base
  belongs_to :question

  def transfer_to_json
    {
      id: id,
      text: text,
    }
  end
end
