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
      if user.valid? && user_params[:password].length >= 4
        user.save
        if params[:company_id].to_s != ""
          redirect_to edit_superuser_company_path(params[:company_id])
        else
          if user.leading
            redirect_to all_leading_superuser_users_path
          else
            redirect_to edit_superuser_user_path(user.id, params: {back_url: params[:back_url]})
          end
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

    def add_favorite_course
      user = find_user
      @courses = Course.all
      @back_url = edit_superuser_user_path(params[:id], params: {company_id: user.company_id, back_url: "company"})
      render :text => "В разработке"
    end

    def all_leading
      @users_leading = User.leading
    end

    def create_favorite_course
      user = find_user
      favorite_course = FavoriteCourse.new({course_id: params[:course_id], user_id: user.id})
      favorite_course.save
      redirect_to edit_superuser_user_path(user.id, params: {company_id: user.company_id, back_url: "company"})
    end

    def remove_favorite_course
      find_favorite_course.destroy
      redirect_to :back
    end

    private

    def find_favorite_course
      FavoriteCourse.find(params[:favorite_course_id])
    end

    def find_user
      User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :director, :corporate, :company_id, :leading)
    end

  end
end
