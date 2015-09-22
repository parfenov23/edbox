class HomeController < ActionController::Base
  helper_method :current_user
  before_action :authorize, except: [:course_description, :render_file]
  before_action :is_corporate?, only: [:group]

  layout "application"

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
      unless @attachment.present? && (current_user.bunch_courses.find_bunch_attachments.where(attachment_id: @attachment.id).present? rescue false)
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

  def tariff
    @current_user = current_user
    if (!@current_user.corporate?) || (@current_user.director)
      @account_type_name = @current_user.get_account_type_name
      @offer_account_type_name = @account_type_name.gsub('Беcплатная', 'Платная')
    else
      render :error
    end
  end

  def members
    @members = current_user.company.users
  end

  def courses
    all_courses = Course.all.order("created_at DESC").publication
    # time = Time.now
    # @new_courses = all_courses.where(created_at: (time - 3.day).beginning_of_day..time.end_of_day)
    #                  .order("created_at ASC")
    @courses = all_courses.where(type_course: "course")
    @courses = all_courses.where(type_course: "online") if params[:type] == "online"
    @courses = all_courses.where(type_course: "material") if params[:type] == "material"
    # binding.pry
    @favorite_courses = current_user.favorite_courses
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

  def render_mini_schedule
    html = render_to_string 'home/cabinet/_schedule', :layout => false, :locals => {params: params}
    render text: html
  end

  # def render_group_program
  #   html = render_to_string 'home/group/_schedule', :layout => false, :locals => {params: params}
  #   render text: html
  # end

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

  def is_contenter?
    redirect_to "/courses" if !current_user.contenter
  end

end
