class HomeController < ActionController::Base
  helper_method :current_user
  before_action :authorize
  before_action :is_corporate?, only: [:group]

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

  def programm
    @course = Course.find(params[:course_id])
    @sections = @course.sections
  end

  def cabinet
    redirect_to "/schedule" unless current_user.director
  end

  def course_description
    @favorite_courses = current_user.favorite_courses
    @course = Course.find(params[:id])
  end

  def group
    @group = (current_user.company.groups.find(params[:id]) rescue nil)
    @members = current_user.company.users
    redirect_to "/group?id=#{(current_user.company.groups.first.id rescue "new")}" unless params[:id].present?
  end

  private

  def current_user
    @current_user ||= User.find_by(user_key: session[:user_key]) if session[:user_key]
    @current_user
  end

  def authorize
    redirect_to "/sign_in" if current_user.nil?
  end

  def is_corporate?
    redirect_to "/" unless current_user.corporate
  end

end
