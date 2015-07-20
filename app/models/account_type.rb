class AccountType < ActiveRecord::Base
  has_many :account_type_relations
end
