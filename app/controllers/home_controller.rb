class HomeController < ActionController::Base
  helper_method :current_user
  before_action :authorize
  before_action :is_corporate?, only: [:group]

  layout "application"

  def index_page
    unless current_user.nil?
      redirect_to '/cabinet'
    else
      redirect_to '/sign_in'
    end
  end

  def show
    render :text => "profile"
  end

  def profile
    @current_user = current_user
  end

  def video
    @current_user = current_user
    attachment = (Attachment.find(params[:id]) rescue nil)
    if attachment.present? && attachment.file_type == 'video'
      @video = attachment
      @section = attachment.attachmentable
      @author = @section.course.user
    else
      render :error
    end
  end

  def audio
    @current_user = current_user
    attachment = (Attachment.find(params[:id]) rescue nil)
    if attachment.present? && attachment.file_type == 'audio'
      @audio = attachment
      @section = attachment.attachmentable
      @author = @section.course.user
    else
      render :error
    end
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
    section_ids = @sections.pluck(:id)
    @tests = Test.where(section_id: section_ids)
  end

  def cabinet
    # redirect_to "/schedule" unless current_user.director
  end

  def render_mini_schedule
    html = render_to_string 'home/cabinet/_schedule', :layout => false, :locals => {params: params}
    render text: html
  end

  # def render_group_program
  #   html = render_to_string 'home/group/_schedule', :layout => false, :locals => {params: params}
  #   render text: html
  # end

  def course_description
    @favorite_courses = current_user.favorite_courses
    @course = Course.find(params[:id])
  end

  def group
    @members = current_user.company.users
    except_params = ["new", "no_group"]
    unless except_params.include?(params[:id])
      if current_user.director
        @group = (current_user.company.groups.find(params[:id]) rescue nil)
        redirect_to "/group?id=#{(current_user.company.groups.first.id rescue "new")}" unless @group.present?
      elsif current_user.corporate
        @group = (current_user.my_groups.find(params[:id]) rescue nil)
        redirect_to "/group?id=#{(current_user.my_groups.first.id rescue "no_group")}" unless @group.present?
      end
    end

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
