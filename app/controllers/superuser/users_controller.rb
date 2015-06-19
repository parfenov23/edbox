module Superuser
  class UsersController < ActionController::Base
    layout "superuser"
    skip_before_action :authorize

    def index
      @users = User.all
    end

    def edit
      @user = User.find(params[:id])
    end

    def new
      @user = User.new
    end

    def create
      user = User.build(user_params)
      if user.valid? && user_params[:password].length > 4
        user.save
        if params[:company_id].to_s != ""
          redirect_to "/superuser/companies/#{params[:company_id]}/edit"
        else
          redirect_to "/superuser/users/#{user.id}/edit"
        end
      else
        back_url = "/superuser/users/new"
        params_error = "?company_id=#{params[:company_id]}&error=error"
        redirect_to back_url + params_error
      end
    end

    def update
      permit_params = user_params
      permit_params.delete(:password) if permit_params[:password].to_s.length == 0
      user = User.find(params[:id])
      if user.valid?
        user.update(permit_params)
        if params[:company_id].to_s != ""
          redirect_to "/superuser/companies/#{params[:company_id]}/edit"
        else
          redirect_to "/superuser/users/#{user.id}/edit"
        end
      else
        back_url = "/superuser/users/#{params[:id]}/edit"
        params_error = "?company_id=#{params[:company_id]}&error=error"
        redirect_to back_url + params_error
      end
    end

    def remove
      User.find(params[:id]).destroy
      redirect_to :back
    end

    private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :director, :corporate, :company_id)
    end

  end
end
