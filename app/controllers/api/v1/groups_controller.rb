module Api::V1
  class GroupsController < ::ApplicationController
    before_action :is_director, only: [:create, :invite,
                                       :remove_user, :remove_course,
                                       :add_course]

    def index
      groups = current_user.all_groups.as_json(:except => Group::EXCEPT_ATTR)
      render json: groups
    end

    def create
      group = Group.find_or_create_by(group_params)
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
      find_sub = current_user.find_subscription
      company_users = current_user.company.users.count rescue 0
      result = {}
      emails = params[:emails]
      group = get_find_group
      unless group.nil?
        arr_hash_users = emails.map do |email|
          validate = true
          user = User.find_by_email(email)
          if current_user.company.users.where(user.as_json).present?
            if user.nil?
              validate = !find_sub.present? ? true : (find_sub.user_count > company_users ? true : false)
            end
            if validate
              user = User.build_default(current_user.company_id, email) if user.nil?
            else
              result[:error] = "Вы превысили лимит приглашения участников"
            end
            if (user.save rescue false)
              BunchGroup.build(user.id, group.id).save
              user.create_notify(group)
              user.transfer_to_json
            end
          else
            result[:error] = "Участник с таким Email не состоит в вашей компании"
          end
        end
      end
      group.build_all_course
      result[:users] = (arr_hash_users.compact rescue render_error(400, 'Проверьте данные'))

      render json: result
    end

    def remove_user
      group = get_find_group
      result = unless group.nil?
                 users = group.company.users.where(id: params[:user_id])
                 users.map do |user|
                   if user.present?
                     user.bunch_groups.where(group_id: group.id).destroy_all
                     user.transfer_to_json if (user.save rescue false)
                   end
                 end.compact
               end
      render json: {users: (result rescue render_error(400, 'Проверьте данные'))}
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
      if params[:date_complete].present?
        if (bunch_course = BunchCourse.build(params[:course_id], params[:group_id], params[:date_complete], "group", nil, params[:sections]) rescue false)
          render json: bunch_course.as_json
        else
          render_error(500, 'Проверьте данные')
        end
      else
        render_error(500, 'Проверьте данные')
      end
    end

    def add_courses
      hash_params = params[:courses]
      hash_params.each do |course|
        course = course.last
        BunchCourse.build(course[:course_id], course[:group_id], course[:date_complete], "group", nil)
      end
      render json: {success: true}
    end

    def update_course
      if params[:date_complete].present?
        if (bunch_course = BunchCourse.build(params[:course_id], get_find_group.id, params[:date_complete], "group", nil, params[:sections]) rescue false)
          render json: bunch_course.as_json
        else
          render_error(500, 'Проверьте данные')
        end
      else
        render_error(500, 'Проверьте данные')
      end
    end

    def update_section
      group = get_find_group
      all_bunch_sections = group.bunch_courses.find_bunch_sections.where(section_id: params[:section_id])
      find_ligament_section = group.find_ligament_section(params[:section_id])
      if find_ligament_section.present?
        find_ligament_section.date_complete = Time.parse(params[:date_complete]).end_of_day
        find_ligament_section.save
      end
      result = all_bunch_sections.update_all({date_complete: Time.parse(params[:date_complete]).end_of_day})
      render json: {result: result.as_json}
    end

    def all_courses
      bunch_courses = (get_find_group.bunch_courses rescue [])
      render json: bunch_courses.as_json
    end

    def remove_course
      ligament_courses = get_find_group.ligament_courses.where(course_id: params[:course_id])
      if (ligament_courses.destroy_all rescue false)
        push_if_delete_course(params[:course_id], get_find_group.id)
        render json: {success: true}
      else
        render_error(500, 'Ошибка сервера')
      end
    end

    private

    def push_if_delete_course(course_id, group_id)
      Thread.new do
        `rake user_notify:remove_course[#{course_id},#{group_id}]`
      end
    end

    def find_bunch_course
      BunchCourse.find(params[:bunch_course_id])
    end

    def is_director
      render_error(401, 'Недостаточно прав') unless current_user.director
    end

    def find_group
      Group.find_by(id: params[:groups][:id], company_id: current_user.company_id) rescue nil
    end

    def get_find_group
      Group.find_by(id: params[:id], company_id: current_user.company_id) rescue nil
    end

    def group_params
      permit_params = params.require(:group).permit(:first_name, :company_id, :description)
      permit_params[:company_id] = current_user.company_id
      permit_params
    end
  end

end
