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

  def members
    @members = current_user.company.users
  end

  def courses
    all_courses = Course.all
    time = Time.now
    @new_courses = all_courses.where(created_at: (time - 3.day).beginning_of_day..time.end_of_day)
                     .order("created_at ASC")
    @courses = all_courses.where.not({id: @new_courses.ids})
    @favorite_courses = current_user.favorite_courses
  end

  def cabinet
    redirect_to "/schedule" unless current_user.director
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
