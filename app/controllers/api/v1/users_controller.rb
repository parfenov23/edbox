require 'base64'
require 'resize_image'
module Api::V1
  class UsersController < ::ApplicationController
    before_action :is_director, only: [:invite, :remove_user]

    def info
      render json: current_user.transfer_to_json
    end

    def invite
      arr_hash_users = []
      emails = params[:emails]
      emails.each do |email|
        user = User.find_by_email(email)
        user = User.build_default(current_user.company_id, email) if user.blank?
        arr_hash_users << user.transfer_to_json if (user.save rescue false)
      end
      render json: {users: arr_hash_users}
    end

    def remove_user
      user = find_user
      user.company_id = nil
      user.corporate = false
      user.director = false
      user.save
      render json: {user: user.transfer_to_json}
    end

    def update
      user = current_user
      permit_params = user_params.compact
      permit_params.delete(:password) if permit_params[:password].to_s.length == 0
      permit_params[:director] = user.director

      if user.valid?
        user.update(permit_params)
        render json: user.transfer_to_json
      else
        render_error(500, 'Проверьте данные')
      end
    end

    def update_course
      if (bunch_course = BunchCourse.build(params[:course_id], nil, params[:date_complete], "user", current_user.id) rescue false)
        render json: bunch_course.as_json
      else
        render_error(500, 'Проверьте данные')
      end
    end

    def remove_course
      current_user.bunch_courses.where({model_type: 'user', course_id: params[:course_id]}).destroy_all
      render json: {success: true}
    end

    def update_section
      section = BunchSection.find(params[:section_id])
      section.date_complete = Time.parse(params[:date_complete]).end_of_day
      if(section.save rescue false)
        render json: section.as_json
      else
        render_error(500, 'Проверьте данные')
      end
    end

    def change_password
      current_user.password = params[:password]
      if (current_user.save rescue false)
        render json: current_user.transfer_to_json
      else
        render_error(500, 'Проверьте данные')
      end
    end

    def update_avatar_string
      current_user.avatar = params[:base64]
      if (current_user.save rescue false)
        render json: {base64: current_user.avatar}
      else
        render_error(500, 'Проверьте данные')
      end
    end

    def update_avatar
      unless params[:avatar].nil?
        img = ResizeImage.crop(params[:avatar].path)
        img_base64 = Base64.encode64(File.open(img.path, "rb").read)
        current_user.avatar = img_base64
        if (current_user.save rescue false)
          render json: {base64: img_base64}
        else
          render_error(500, 'Проверьте данные')
        end
      else
        render json: {error: "You do not pass the picture"}
      end
    end

    def add_favorite_course
      favorite_course = FavoriteCourse.find_or_create_by({course_id: params[:course_id], user_id: current_user.id})
      if (favorite_course.save rescue false)
        render json: favorite_course.transfer_to_json
      else
        render_error(500, 'Проверьте данные')
      end
    end

    def remove_favorite_course
      find_favorite_course.destroy
      render json: {success: true}
    end

    private

    def find_favorite_course
      current_user.favorite_courses.find(params[:favorite_course_id])
    end

    def find_user
      User.find(params[:id])
    end

    def is_director
      render_error(401, 'Недостаточно прав') unless current_user.director
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :director, :corporate, :company_id, :job)
    end

  end

end
