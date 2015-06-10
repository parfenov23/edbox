module Api::V1
  class SessionsController < ::ActionController::Base
    skip_before_filter :verify_authenticity_token
    protect_from_forgery unless: -> { request.format.json? }
    def auth
      render :text => "test"
    end

    def registration
      user = User.build(user_params)
      user.password_digest = user_params[:password]
      if user.save
        user_hash = user.as_json
        user_hash.delete("password_digest")
      else
        user_hash = {error: user.errors.messages}
      end
      render json: user_hash
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end

  end

end
