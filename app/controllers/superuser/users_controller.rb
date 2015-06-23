module Superuser
  class UsersController < ActionController::Base
    layout "superuser"
    skip_before_action :authorize

    def index
      @users = User.all
    end

    def edit
      @user = find_user
      @back_url = edit_superuser_company_path(params[:company_id]) if params[:back_url] == "company"
    end

    def new
      @user = User.new
      @back_url = edit_superuser_group_path(params[:group_id]) if params[:back_url] == "groups"
      @back_url = edit_superuser_company_path(params[:company_id]) if params[:back_url] == "company"
    end

    def create
      user = User.build(user_params)
      if user.valid? && user_params[:password].length > 4
        user.save
        if params[:company_id].to_s != ""
          redirect_to edit_superuser_company_path(params[:company_id])
        else
          redirect_to edit_superuser_user_path(user.id, params: {back_url: params[:back_url]})
        end
      else
        back_url = new_superuser_user_path
        params_error = "?company_id=#{params[:company_id]}&error=error&back_url=#{params[:back_url]}"
        redirect_to back_url + params_error
      end
    end

    def update
      permit_params = user_params
      permit_params.delete(:password) if permit_params[:password].to_s.length == 0
      user = find_user
      if user.valid?
        user.update(permit_params)
        if params[:company_id].to_s != ""
          redirect_to edit_superuser_company_path(params[:company_id])
        else
          redirect_to edit_superuser_user_path(user.id)
        end
      else
        back_url = "/superuser/users/#{params[:id]}/edit"
        params_error = "?company_id=#{params[:company_id]}&error=error"
        redirect_to back_url + params_error
      end
    end

    def remove
      find_user.destroy
      redirect_to :back
    end

    private

    def find_user
      User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :director, :corporate, :company_id)
    end

  end
end
