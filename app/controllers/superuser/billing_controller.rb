module Superuser
  class BillingController < SuperuserController
    def index
      @users = User.where(user_params).where.not(["corporate = ? and director = ?", true, false])
      params_user = params[:user].present? ? params[:user] : {}
      if params_user[:created_at_from].present? || params_user[:created_at_from].present?
        time_from = Time.parse(params_user[:created_at_from]).beginning_of_day rescue nil
        time_to = Time.parse(params_user[:created_at_to]).end_of_day rescue nil
        @users = @users.where(make_up_where_from_date(time_from, time_to))
      end
      if params_user[:sub_from].present? || params_user[:sub_to].present?
        time_from = Time.parse(params_user[:sub_from]).beginning_of_day rescue nil
        time_to = Time.parse(params_user[:sub_to]).end_of_day rescue nil
        @users = @users.select{|u|
          sub = u.find_subscription([false, true])
          sub.present? ? (time_from.present? ? sub.date_from : true) <= time_from && (time_to.present? ? sub.date_to >= time_to : true) : false
        }
      end
      if params_user[:acc_paid].present?
        @users = @users.select{|u| u.find_subscription.present?.to_s == params_user[:acc_paid]}
      end
    end

    def edit
      @subscription = find_subscription
    end

    def new
      @subscription = Subscription.new(sub_params)
    end

    def create
      find_params = sub_params
      find_params[:sum] = find_params[:sum].to_f if find_params[:sum].blank?
      sub = Subscription.new(find_params)
      sub.save
      redirect_to edit_superuser_billing_path(sub.id, params: {error: "save"})
    end

    def update
      find_params = sub_params
      find_params[:sum] = find_params[:sum].to_f if find_params[:sum].blank?
      sub = find_subscription
      sub.update(find_params)
      redirect_to :back
    end

    def all
      @user = find_user
      @subscriptions = @user.find_subscription([true, false], false, "all")
    end

    def remove
      find_subscription.destroy
      redirect_to :back
    end

    def edit_price
      @billing_price = BillingPrice.default
    end

    def update_price
      BillingPrice.default.update(billing_price_params)
      redirect_to :back
    end

    private

    def find_subscription
      Subscription.find(params[:id])
    end

    def find_user
      User.find(params[:id])
    end

    def billing_price_params
      params.require(:billing_price).permit(:user_price,
                                            :company_price,
                                            :company_user_price, :test_user_price).compact.select { |k, v| v != "" } rescue {}
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name,
                                   :password, :director, :corporate,
                                   :company_id, :leading, :about_me,
                                   :contenter, :superuser, :paid).compact.select { |k, v| v != "" } rescue {}
    end

    def sub_params
      params.require(:subscription).permit(:date_from, :date_to, :subscriptiontable_type, :sum,
                                           :subscriptiontable_id, :active, :user_count, :note).compact.select { |k, v| v != "" } rescue {}
    end

  end
end
