require 'base64'
require 'resize_image'
module Api::V1
  class UsersController < ::ApplicationController
    before_action :is_director, only: [:invite, :remove_user]
    skip_before_action :authorize, only: [:send_request]

    def info
      render json: current_user.transfer_to_json
    end

    def send_request
      HomeMailer.sendRequest(params).deliver
      render json: {success: "good"}
    end

    def invite
      find_sub = current_user.find_subscription
      company_users = current_user.company.users.count rescue 0
      validate = !find_sub.present? ? true : (find_sub.user_count > company_users ? true : false)
      if validate
        arr_hash_users = []
        emails = params[:emails]
        emails.each do |email|
          user = User.find_by_email(email)
          if user.blank?
            company_id = params[:leading].blank? ? current_user.company_id : nil
            user = User.build_default(company_id, email)
          end
          user.leading = params[:leading] if params[:leading].present?
          arr_hash_users << user.transfer_to_json if (user.save rescue false)
        end
        result = {users: arr_hash_users}
      else
        result = {error: "Вы превысили лимит приглашения участников"}
      end
      render json: result
    end

    def remove_user
      User.where(id: params[:id]).destroy_all
      render json: {success: true}
    end

    def remove_user_leading
      user = User.where(id: params[:id])
      user.update_all({leading: false})
      render json: {success: true}
    end

    def update
      user = current_user
      permit_params = user_params.compact
      permit_params.delete(:password) unless permit_params[:password].present?
      permit_params[:director] = user.director

      if user.valid?
        user.update(permit_params)
        render json: user.transfer_to_json
      else
        render_error(500, 'Проверьте данные')
      end
    end

    def update_course
      course = Course.find(params[:course_id])
      if (BunchCourse.build(course.id, nil, nil, "user", current_user.id, params[:sections]))
        render json: {success: true}
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
      section.update({date_complete: params[:date_complete]})
      if (section.save rescue false)
        render json: section.as_json
      else
        render_error(500, 'Проверьте данные')
      end
    end

    def remove_section_deadline
      section = BunchSection.find(params[:bunch_section_id])
      section.date_complete = nil
      if (section.save rescue false)
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
      current_user.avatar = params[:base64].to_s.gsub(" ", "+")
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
      added_course = current_user.favorite_courses.where(course_id: params[:course_id]).last
      unless added_course.present?
        favorite_course = FavoriteCourse.find_or_create_by({course_id: params[:course_id], user_id: current_user.id})
        if (favorite_course.save rescue false)
          render json: {favorite_course: favorite_course.transfer_to_json, success: true}
        else
          render_error(500, 'Проверьте данные')
        end
      else
        render json: {favorite_course: added_course.transfer_to_json, success: false}
      end
    end

    def remove_favorite_course
      find_favorite_course.destroy
      render json: {success: true}
    end

    def my_courses
      render json: Course.where(id: current_user.bunch_courses.map(&:course_id)).map { |ca| ca.transfer_to_json_mini((current_user.id rescue nil)) }
    end

    private

    def find_favorite_course
      current_user.favorite_courses.find(params[:favorite_course_id])
    end

    def find_user
      User.find(params[:id])
    end

    def is_director
      render_error(401, 'Недостаточно прав') unless current_user.director || current_user.contenter
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name,
                                   :password, :director, :corporate,
                                   :company_id, :job)
    end

  end

end
