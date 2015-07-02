module Api::V1
  class GroupsController < ::ApplicationController
    before_action :is_director, only: [:create, :invite, :remove_user]

    def index
      groups = current_user.all_groups.as_json(:except => Group::EXCEPT_ATTR)
      render json: groups
    end

    def create
      group = Group.new(group_params)
      if (group.save rescue false)
        render json: group.as_json
      else
        render_error(400, 'Проверьте данные')
      end
    end

    def show
      group = find_group
      unless group.nil?
        group_json = group.transfer_to_json
        group_json[:users] = group.bunch_groups.map { |bg| bg.user.transfer_to_json }
        render json: group_json
      else
        render_error(400, 'Проверьте данные')
      end
    end

    def invite
      emails = params[:emails]
      group = get_find_group
      unless group.nil?
        arr_hash_users = emails.map do |email|
          user = User.find_by_email(email)
          user = User.build_default(current_user.company_id, email) if user.nil?
          if (user.save rescue false)
            BunchGroup.build(user.id, group.id).save
            user.transfer_to_json
          end
        end
      end
      render json: {users: (arr_hash_users.compact rescue render_error(400, 'Проверьте данные'))}
    end

    def remove_user
      emails = params[:emails]
      group = get_find_group
      arr_hash_users = []
      unless group.nil?
        users = group.company.users
        arr_hash_users = emails.map do |email|
          user = users.find_by_email(email)
          user.bunch_groups.where(group_id: group.id).destroy_all
          user.transfer_to_json if (user.save rescue false)
        end
      end
      render json: {users: (arr_hash_users.compact rescue render_error(400, 'Проверьте данные'))}
    end

    def destroy
      group = get_find_group
      unless group.nil?
        BunchGroup.where(group_id: group.id).destroy_all
        group.destroy
      end
      render json: {success: true}
    end

    def update
      group = get_find_group
      group.update(group_params) unless group.nil?
      render json: group.transfer_to_json
    end

    def add_course
      bunch_course = BunchCourse.build(params[:course_id], params[:group_id], params[:date_start])
      if (bunch_course.save rescue false)
        render json: bunch_course.as_json
      else
        render_error(500, 'Проверьте данные')
      end
    end

    def update_course
      if (find_bunch_course.nil? rescue true)
        bunch_course = BunchCourse.build(params[:course_id], params[:id], params[:date_start])
      else
        bunch_course = find_bunch_course.update({date_start: Time.parse(params[:date_start]),
                                                 course_id: params[:course_id],
                                                 group_id: params[:id]})
      end
      if (bunch_course.save rescue false)
        render json: bunch_course.transfer_to_json
      else
        render_error(500, 'Ошибка сервера')
      end
    end

    def all_courses
      bunch_courses = (get_find_group.bunch_courses rescue [])
      render json: bunch_courses.as_json
    end

    def remove_course
      if (find_bunch_course.to_archive rescue false)
        render json: {success: true}
      else
        render_error(500, 'Ошибка сервера')
      end
    end

    private

    def find_bunch_course
      BunchCourse.find(params[:bunch_course_id])
    end

    def is_director
      render_error(401, 'Недостаточно прав') unless current_user.director
    end

    def find_group
      Group.find_by(id: params[:group][:id], company_id: current_user.company_id) rescue nil
    end

    def get_find_group
      Group.find_by(id: params[:id], company_id: current_user.company_id) rescue nil
    end

    def group_params
      permit_params = params.require(:group).permit(:first_name, :company_id)
      permit_params[:company_id] = current_user.company_id
      permit_params
    end
  end

end
