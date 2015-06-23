class HomeController < ActionController::Base
  helper_method :current_user
  before_action :authorize

  layout "application"

  def show
    render :text => "profile"
  end

  def profile
    @current_user = current_user
  end

  private

  def current_user
    @current_user ||= User.find_by(user_key: session[:user_key]) if session[:user_key]
    @current_user
  end

  def authorize
    redirect_to "/#signin" if current_user.nil?
  end

end
