class ApplicationController < ActionController::Base
  before_action :authorize
  helper_method :current_user
  # skip_before_action :authorize

  def render_error(code, message = nil)
    json_response = {error: message} if message
    render json: json_response, status: code
  end

  protected

  def current_user
    user_key = request.headers['HTTP_USER_KEY']
    @current_user ||= User.find_by(user_key: user_key) if user_key
    @current_user
  end

  def authorize
    return render json: { error: 'Not authorized' }, status: :unauthorized unless current_user
  end

end
