class AskQuestion < ActiveRecord::Base
  has_many :page_questions, dependent: :destroy
end
