class Subscription < ActiveRecord::Base
  belongs_to :subscriptiontable, :polymorphic => true

  def self.build(params)
    sub = new(params)
    if params[:type] == "new_user"
      user = User.build({email: params[:email], password: SecureRandom.hex(6)})
      user.save
    else
      user = User.find(params[:user_id])
    end
    subscription_model = user.director? ? (user.company rescue user) : user
    sub.subscriptiontable_type = subscription_model.class.to_s
    sub.subscriptiontable_id = subscription_model.id
  end
end
