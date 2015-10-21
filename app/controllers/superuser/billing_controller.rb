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
    end

    private


    def find_user
      User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name,
                                   :password, :director, :corporate,
                                   :company_id, :leading, :about_me,
                                   :contenter, :superuser, :paid).compact.select { |k, v| v != "" } rescue {}
    end

  end
end
