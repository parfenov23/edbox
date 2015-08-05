class Notification < ActiveRecord::Base
  belongs_to :notifytable, :polymorphic => true
  belongs_to :user
  before_save :push

  def push
    user = self.user
    type = notifytable_type
    data_params = notifytable.notify_json(action_type)
    data_params[:type] = type
    Fiber.new{ WebsocketRails[user.user_key].trigger 'notification', data_params }.resume
  end

end
