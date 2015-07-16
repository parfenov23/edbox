module Api::V1
  class SessionsController < ::ApplicationController
    # skip_before_filter :verify_authenticity_token
    # protect_from_forgery unless: -> { request.format.json? }
    skip_before_action :authorize

    def auth
      user_auth = User.auth(params[:user])
      unless user_auth.nil?
        session[:user_key] = user_auth["user_key"]
        render json: user_auth
      else
        render_error(401, 'Не удалось пройти аутентификацию, проверьте введенные данные')
      end
    end

    def registration
      permit_params = user_params
      permit_params[:corporate] = "true" if (params[:company][:name].to_s.length > 0 rescue false)
      permit_params[:director] = permit_params[:corporate].to_s
      if permit_params[:director].to_s == "true"
        company = Company.build(params[:company])
        permit_params[:company_id] = company.id if company.save
      end
      user = User.build(permit_params)
      if (user.save rescue false)
        session[:user_key] = user["user_key"]
        render json: user.transfer_to_json
      else
        company.destroy unless (company.nil? rescue true)
        render_error(401, 'Не удалось пройти регистрацию, проверьте введенные данные')
      end
    end

    def recover_password
      result = (User.find_by_email(params[:email]).random_password rescue nil)
      if result.present?
        render json: {success: true}
      else
        render_error(500, 'Проверьте данные')
      end
    end

    def signout
      session[:user_key] = nil
      render json: {success: true}
    end

    private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :director, :corporate, :company_id)
    end

  end

end
