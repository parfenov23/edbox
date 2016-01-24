class BillingPrice < ActiveRecord::Base
  def self.default
    if last.present?
      last
    else
      create
    end
  end
end
