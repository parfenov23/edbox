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
      if params_user[:acc_paid].present?
        user_ids = @users.where(corporate: false, paid: params_user[:acc_paid]).ids
        user_ids += @users.joins(:company).where({"companies.paid" => params_user[:acc_paid]}).ids
        @users = User.where(id: user_ids)
      end
    end

    def edit
      @subscription = find_subscription
    end

    def new
      @subscription = Subscription.new(sub_params)
    end

    def create
      sub = Subscription.new(sub_params)
      sub.save
      redirect_to edit_superuser_billing_path(sub.id)
    end

    private

    def find_subscription
      Subscription.find(params[:id])
    end

    def find_user
      User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name,
                                   :password, :director, :corporate,
                                   :company_id, :leading, :about_me,
                                   :contenter, :superuser, :paid).compact.select { |k, v| v != "" } rescue {}
    end

    def sub_params
      params.require(:subscription).permit(:date_from, :date_to, :subscriptiontable_type,
                                           :subscriptiontable_id, :active).compact.select { |k, v| v != "" } rescue {}
    end

  end
end
