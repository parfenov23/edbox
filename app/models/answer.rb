class Answer < ActiveRecord::Base
  belongs_to :question
  default_scope { order("id ASC") }

  def transfer_to_json
    {
      id: id,
      text: text,
    }
  end
end
