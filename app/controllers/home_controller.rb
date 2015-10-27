class HomeController < ActionController::Base
  helper_method :current_user
  before_action :authorize, except: [:course_description, :render_file,
                                     :courses, :attachment, :course_no_reg, :help, :help_answer, :pay]
  before_action :is_corporate?, only: [:group]
  before_action :back_url
  layout "application"
  # caches_page :courses

  def index_page
    unless current_user.nil?
      unless current_user.contenter
        redirect_to '/cabinet'
      else
        (Rails.env.production?) ? (redirect_to '/contenter/courses') : (redirect_to '/cabinet')
      end
    else
      redirect_to '/sign_in'
    end
  end

  def render_file
    att = Attachment.find(params[:id])
    send_file att.file.path
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
      redirect_to "/cabinet"
    end
  end

  def attachment
    @attachment = Attachment.where(id: params[:id]).last
    @section = @attachment.attachmentable rescue nil
    @course = @attachment.attachmentable_type != "Course" ? (@section.course rescue nil) : @section
    unless (@course.material? rescue false)
      valid_added = (current_user.bunch_courses.find_bunch_attachments.where(attachment_id: @attachment.id).present? rescue false)
      valid_redirect = current_user.present? ? valid_added : @attachment.public
      unless @attachment.present? && valid_redirect
        redirect_to "/"
      end
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

  def pdf
    @current_user = current_user
    attachment = (Attachment.find(params[:id]) rescue nil)
    if attachment.present? && attachment.file.file.extension.downcase == 'pdf'
      @pdf = attachment
      @section = attachment.attachmentable
    else
      render :error
    end
  end

  def members
    @members = current_user.company.users.where({director: false})
  end

  def courses
    @courses_cid = nil
    type_course = params[:type].present? ? params[:type] : "course"
    @courses = Course.all.publication.where(type_course: type_course)
    if params[:cid].present?
      @courses_cid = @courses.joins(:bunch_categories).where("bunch_categories.category_id" => params[:cid])
    end
  end

  def programm
    @course = Course.find(params[:id])
    @sections = @course.sections
    section_ids = @sections.pluck(:id)
    @tests = Test.where(section_id: section_ids)
  end

  def cabinet
    @favorite_courses = current_user.favorite_courses
    # redirect_to "/schedule" unless current_user.director
  end

  def help_answer
    @page_question = PageQuestion.find(params[:id])
  end

  def render_mini_schedule
    html = render_to_string 'home/cabinet/_schedule', :layout => false, :locals => {params: params}
    render text: html
  end

  # def render_group_program
  #   html = render_to_string 'home/group/_schedule', :layout => false, :locals => {params: params}
  #   render text: html
  # end

  def course_no_reg
    @course = Course.find(params[:id])
  end

  def pay
    params_sub = params
    user = User.where(email: params_sub[:email]).last
    user.present? ? params_sub[:user_id] = user.id : params_sub[:type] = "new_user"
    params_sub[:type_account] == "user" ? params_sub[:sum] = 1490.00 : params_sub[:sum] = 50000.00

    subscription = Subscription.build(params_sub)
    subscription.save
    html = render_to_string 'common/popup_request/_yandex_cash', :layout => false, :locals => {params_sub: params_sub, :subscription => subscription}
    render text: html
  end

  def course_description
    # @favorite_courses = current_user.favorite_courses
    @course = Course.find(params[:id])
    bunch_course = current_user.bunch_courses.where(course_id: @course.id).last rescue nil
    test_final = @course.test
    if test_final.present?
      test_final_result = (test_final.test_results.where(user_id: current_user.id).last) rescue true
      if bunch_course.present? && (bunch_course.full_complete? rescue false) && test_final_result.blank? && params[:attachment_id].present?
        redirect_to "/tests/#{test_final.id}/run"
      end
    end
    if @course.material?
      unless @course.find_bunch_course(current_user.id, ["user", "group"]).present?
        redirect_to "/courses"
      else
        attachment = @course.attachments.last
        redirect_to attachment.present? ? "/attachment?id=#{attachment.id}" : "/"
      end
    end
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

  def back_url
    begin
      if request.get?
        session[:histories] = [] if !session[:histories].present?
        session[:histories] << request.fullpath if request.fullpath != session[:histories].last
        session[:back_url] = session[:histories].present? ? session[:histories].last(2).first : request.fullpath
      end
    rescue
      nil
    end
  end

  def current_user
    @current_user ||= User.find_by(user_key: session[:user_key]) if session[:user_key]
    @current_user
  end

  def authorize
    redirect_to '/courses' if current_user.nil?
  end

  def is_corporate?
    redirect_to "/" unless current_user.corporate
  end

  def is_contenter?
    redirect_to "/courses" if !current_user.contenter
  end

end
