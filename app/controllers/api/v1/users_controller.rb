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

    private

    def is_director
      render_error(401, 'Недостаточно прав') unless current_user.director
    end

  end

end
