class Subscription < ActiveRecord::Base
  belongs_to :subscriptiontable, :polymorphic => true

  def self.build(params)
    sub = new(find_params(params))
    if params[:type] == "new_user"
      user = User.build({email: params[:email], password: SecureRandom.hex(6)})
      user.save
    else
      user = User.find(params[:user_id])
    end
    subscription_model = user.director? ? (user.company rescue user) : user
    sub.subscriptiontable_type = subscription_model.class.to_s
    sub.subscriptiontable_id = subscription_model.id
    sub.active = false
    sub
  end

  def self.find_params(params)
    params.permit(:date_from, :date_to, :subscriptiontable_type, :sum,
                  :subscriptiontable_id, :active).compact.select { |k, v| v != "" } rescue {}
  end

  def date_string
    (date_from.strftime('%d.%m.%Y %H:%M') + " по " + date_to.strftime('%d.%m.%Y %H:%M')) rescue nil
  end
end