module Api::V1
  class UsersController < ::ApplicationController
    before_action :is_director, only: [:invite]

    def info
      render json: current_user.transfer_to_json
    end

    def invite
      arr_hash_users = []
      emails = params[:emails]
      emails.each do |email|
        user = User.build_default(current_user.company_id, email)
        arr_hash_users << user.transfer_to_json if (user.save rescue false)
      end
      render json: {users: arr_hash_users}
    end

    def update
      user = find_user
      permit_params = user_params
      permit_params.delete(:password) if permit_params[:password].to_s.length == 0
      permit_params[:director] = user.director

      if user.valid?
        user.update(permit_params)
        render json: user.transfer_to_json
      else
        render_error(500, 'Проверьте данные')
      end
    end

    private

    def is_director
      render_error(401, 'Недостаточно прав') unless current_user.director
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :director, :corporate, :company_id)
    end

  end

end
