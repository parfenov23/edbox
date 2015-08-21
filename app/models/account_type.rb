class AccountType < ActiveRecord::Base
  has_many :account_type_relations
  has_many :courses
end
