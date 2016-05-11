module Superuser
  class DeliveryController < SuperuserController

    def index
      @deliveries = Delivery.all
    end

    def new
      @delivery = Delivery.new
      @users = find_users
      @all_params = {user: params_users}
    end

    def edit
      @delivery = find_delivery
      @users = @delivery.users
    end

    def update
      params_delivery_edit = params_delivery
      params_delivery_edit[:users_id] = eval(params_delivery[:users_id])
      find_delivery.update(params_delivery_edit)
      redirect_index_path("save")
    end

    def result
      @users = params[:id].blank? ? find_users : find_delivery.users
    end

    def create
      arr_users = params_delivery[:users_id]
      delivery = Delivery.new(params_delivery)
      delivery.users_id = eval(arr_users)
      delivery.save
      redirect_index_path("save")
    end

    def remove
      find_delivery.destroy
      redirect_index_path("delete")
    end

    def send_mail
      delivery = find_delivery
      delivery.users.each do |user|
        description = delivery.description_to_text(user)
        DeliveryMailer.send_mail(user.email, delivery.title, description).deliver
      end
      redirect_index_path("complete")
    end

    private

    def redirect_index_path(error="save")
      redirect_to "/superuser/delivery?error=#{error}"
    end

    def find_delivery
      Delivery.find(params[:id])
    end

    def find_users
      where_hash = params_users.select{|k, v| v.present? }.slice(:corporate, :id, :email)
      where_hash[:id] = eval(where_hash[:id]) if where_hash[:id].present?
      where_hash[:email] = where_hash[:email].gsub(' ', '').split(',') if where_hash[:email].present?
      all_users = User.where(where_hash)

      if params_users[:sub_from].present? || params_users[:sub_to].present?
        time_from = Time.parse(params_users[:sub_from]).beginning_of_day rescue nil
        time_to = Time.parse(params_users[:sub_to]).end_of_day rescue nil
        all_users = all_users.select{|u|
          sub = u.find_subscription([false, true])
          sub.present? ? (time_from.present? ? sub.date_from : true) <= time_from && (time_to.present? ? sub.date_to >= time_to : true) : false
        }
      end

      if params_users[:billing] == "false"
        all_users = all_users.select{|u|
          sub = u.find_subscription
          sub.blank? || (sub.overdue? rescue true)
        }
      end

      @all_users = User.where(id: all_users.map(&:id))
    end

    def params_users
      params.require(:user).permit(:corporate, :id, :email, :role, :sub_from, :sub_to, :billing).compact rescue {}
    end

    def params_delivery
      params.require(:delivery).permit(:title, :description, :users_id).compact rescue {}
    end

  end
end
