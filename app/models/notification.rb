class Notification < ActiveRecord::Base
  belongs_to :notifytable, :polymorphic => true
  belongs_to :user
  before_save :push

  def push
    user = self.user
    type = notifytable_type
    data_params = case type
                    when "Group"
                      {title: "Вас добавили в группу", body: "Директор пригласил вас в группу"}
                    else
                      {}
                  end
    data_params[:type] = type
    WebsocketRails[user.user_key].trigger 'new', data_params

  end

end
