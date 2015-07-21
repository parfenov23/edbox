class AccountTypeRelation < ActiveRecord::Base
  belongs_to :modelable, :polymorphic => true
  belongs_to :account_type
end
