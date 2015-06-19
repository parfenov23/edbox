class ApplicationController < ActionController::Base
  include ActionController::ImplicitRender
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token
  protect_from_forgery unless: -> { request.format.json? }
  before_action :authorize
  helper_method :current_user
  skip_before_action :authorize, only: [:index]

  def index
    render layout: 'layouts/application'
  end

  def render_error(code, message = nil)
    json_response = {error: message} if message
    render json: json_response, status: code
  end

  def current_user(request_value=nil)
    request_value = request if request_value.nil?
    user_key = request_value.headers['HTTP_USER_KEY']
    @current_user ||= User.find_by(user_key: user_key) if user_key
    @current_user
  end

  protected

  def authorize
    return render json: { error: 'Not authorized' }, status: :unauthorized unless current_user
  end

end
