class BillingPrice < ActiveRecord::Base
  def self.default
    last.present? ? last : create
  end
end
