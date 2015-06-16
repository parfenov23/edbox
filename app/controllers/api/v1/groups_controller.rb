module Api::V1
  class GroupsController < ::ApplicationController
    before_action :is_director, only: [:create, :invite, :remove_user]

    def index
      groups = current_user.all_groups.as_json(:except => Group.except_attr)
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
        group_json = group.as_json.as_json(:except => Group.except_attr)
        group_json[:users] = group.users.as_json(:except => User.except_attr)
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
          if user.nil?
            user = User.build(
              {
                email: email,
                first_name: "Пользователь",
                director: false,
                corporate: true,
                company_id: current_user.company_id,
                password: SecureRandom.hex(8),
                group_id: group.id
              }
            )
          else
            user.group_id = group.id
          end
          user.transfer_to_json if (user.save rescue false)
        end
      end
      render json: {users: arr_hash_users.compact}
    end

    def remove_user
      emails = params[:emails]
      group = get_find_group
      arr_hash_users = []
      unless group.nil?
        users = group.users
        arr_hash_users = emails.map do |email|
          user = users.find_by_email(email)
          user.group_id = nil unless user.nil?
          user.transfer_to_json if (user.save rescue false)
        end
      end
      render json: {users: arr_hash_users.compact}
    end

    def destroy
      group = get_find_group
      unless group.nil?
        group.users.each do |user|
          user.group_id = nil
          user.save
        end
        group.destroy
      end
      render json: {success: true}
    end

    def update
      group = get_find_group
      group.update(group_params) unless group.nil?
      render json: group.as_json(:except => Group.except_attr)
    end

    private

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
