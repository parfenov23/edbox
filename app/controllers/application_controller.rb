class ApplicationController < ActionController::Base
  before_action :authorize
  helper_method :current_user
  skip_before_action :authorize, only: [:index_page]

  def index_page
    if @current_user
      redirect_to '/shedule'
    else
      redirect_to '/sign_in'
    end
  end

  def render_error(code, message = nil)
    json_response = {error: message} if message
    render json: json_response, status: code
  end

  protected

  def current_user(request_value=nil)
    request.headers['HTTP_USER_KEY'] = session[:user_key]
    request_value = request if request_value.nil?
    user_key = request_value.headers['HTTP_USER_KEY']
    @current_user ||= User.find_by(user_key: user_key) if user_key
    @current_user
  end

  def authorize
    return render json: { error: 'Not authorized' }, status: :unauthorized unless current_user
  end

end
