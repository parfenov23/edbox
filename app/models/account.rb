class Account < ActiveRecord::Base
  belongs_to :user

  def title
    "#{card_type} #{card_first_six[0]}*** **** **** #{card_last_four} #{issuer_bank_country}"
  end
end
