module Api::V1
  class SessionsController < ::ApplicationController
    skip_before_filter :verify_authenticity_token
    protect_from_forgery unless: -> { request.format.json? }
    skip_before_action :authorize

    def auth
      user_auth = User.auth(params[:user])
      unless user_auth.nil?
        render json: user_auth
      else
        render_error(401, 'Не удалось пройти аутентификацию, проверьте введенные данные')
      end
    end

    def registration
      permit_params = user_params
      permit_params[:director] = permit_params[:corporate].to_s
      if permit_params[:director].to_s == "true"
        company = Company.build(params[:company])
        if company.save
          permit_params[:company_id] = company.id
        end
      end
      user = User.build(permit_params)
      if (user.save rescue false)
        render json: user.transfer_to_json
      else
        company.destroy unless (company.nil? rescue true)
        render_error(401, 'Не удалось пройти регистрацию, проверьте введенные данные')
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :director, :corporate, :company_id)
    end

  end

end
