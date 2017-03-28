require 'social/socials'
module Api::V1
  class SessionsController < ::ApplicationController
    # skip_before_filter :verify_authenticity_token
    # protect_from_forgery unless: -> { request.format.json? }
    skip_before_action :authorize

    def auth
      user_auth = User.auth(params[:user])
      unless user_auth.nil?
        session[:user_key] = user_auth["user_key"]
        Rails.cache.clear rescue nil
        render json: user_auth
      else
        render_error(401, 'Не удалось пройти аутентификацию, проверьте введенные данные')
      end
    end


    def registration
      permit_params = user_params
      permit_params[:email] = permit_params[:email].downcase
      permit_params[:corporate] = "true" if (params[:company][:name].to_s.length > 0 rescue false)
      permit_params[:director] = permit_params[:corporate].to_s
      permit_params[:social] = params[:user][:social]
      if permit_params[:director].to_s == "true"
        company = Company.build(params[:company])
        permit_params[:company_id] = company.id if company.save
      end
      user = User.build(permit_params)
      if (user.save rescue false)
        session[:user_key] = user["user_key"]
        Rails.cache.clear rescue nil
        ApiClients::Mailchimp.new.create_member({email_address: user.email, status: "subscribed", 
          :merge_fields=>{:FNAME=>user.first_name, :LNAME=>user.last_name, 
            MMERGE3: user.social["phone"], CLASS: 0, KID_NAME: "", PROMOCODE: "", TARIF: "Бесплатно"}
            })
        render json: user.transfer_to_json
      else
        company.destroy unless (company.nil? rescue true)
        t1 = 'Пользователь с таким Email уже зарегестрирован'
        t2 = 'Не удалось пройти регистрацию, проверьте введенные данные'
        error_title = User.find_by_email(permit_params[:email]).present? ? t1 : t2
        render_error(401, error_title)
      end
    end

    def recover_password
      result = (User.find_by_email(params[:email].downcase).random_password rescue nil)
      if result.present?
        render json: {success: true}
      else
        render_error(500, 'Проверьте данные')
      end
    end

    def signout
      Rails.cache.clear rescue nil
      session[:user_key] = nil
      render json: {success: true}
    end

    def social
      if params[:access_token].present?
        @info = Socials.reg_params(params[:type], params)
        binding.pry
      end
      render "enter/social"
      # render html: "".html_safe
    end

    private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, 
        :director, :corporate, :company_id, :avatar, :social, :kid_name, :kid_class, :city)
    end

  end

end
