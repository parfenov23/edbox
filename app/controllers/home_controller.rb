class HomeController < ActionController::Base
  helper_method :current_user
  helper_method :subdomain
  before_action :authorize, except: [:course_description, :render_file,
                                     :courses, :attachment, :course_no_reg,
                                     :help, :help_answer, :pay, :index, :auth_user, :info_pay, :user,
                                     :course_cert, :instrument, :courses_rss]
  before_action :is_corporate?, only: [:group]
  before_action :back_url
  layout "application"
  rescue_from Exception, with: :error_message if $env_mode.prod?
  # caches_page :courses
  def index
    @block_registr = false
    unless current_user.nil?
      unless current_user.contenter
        redirect_to '/courses'
      else
        (Rails.env.production?) ? (redirect_to '/contenter/courses') : (redirect_to '/cabinet')
      end
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
    @attachment = Attachment.find_by_id(params[:id])
    if @attachment.present?
      @section = @attachment.attachmentable rescue nil
      @course = @attachment.attachmentable_type != "Course" ? (@section.course rescue nil) : @section
      unless (@course.material? rescue false)
        valid_added = (current_user.bunch_courses.find_bunch_attachments.where(attachment_id: @attachment.id).present? rescue false)
        valid_redirect = current_user.present? ? valid_added : @attachment.public
        course_leading = (@attachment.class_type == 'webinar' ? @attachment.webinar.ligament_leads.where(user_id: current_user.id).present? : false) rescue false
        unless @attachment.present? && valid_redirect || course_leading
          redirect_to "/"
        end
      end
    else
      redirect_to "/"
    end
  end

  def instrument
    @attachment = Attachment.find_by_id(params[:id])
    @section = @attachment.attachmentable rescue nil
    @course = @attachment.attachmentable_type != "Course" ? (@section.course rescue nil) : @section
    @og = @course.og_all
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
    type_course = params[:type].present? ? params[:type] : ['course', 'online', 'material']
    @courses = Course.all.publication.where(type_course: type_course)
    if params[:tid].present?
      @courses_tid = @courses.joins(:bunch_tags).where("bunch_tags.tag_id" => params[:tid])
    end
    @courses = @courses.sort { |a, b| a.min_date_webinar <=> b.min_date_webinar } if params[:type] == "online"
  end

  def courses_rss
    self.courses
    respond_to do |format|
      format.rss { render :layout => false }
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
    @course = Course.find_by_id(params[:id])
    page_404 if @course.blank?
  end

  def pay
    params_sub = params
    user = User.where(email: params_sub[:email]).last
    user.present? ? params_sub[:user_id] = user.id : params_sub[:type] = "new_user"
    (params_sub[:type_account] == "user" ? params_sub[:sum] = 1490.00 : params_sub[:sum] = 50000.00) if params[:sum].blank?
    subscription = Subscription.build(params_sub)
    subscription.save
    #html = render_to_string 'common/popup_request/_yandex_cash', :layout => false, :locals => {params_sub: params_sub, :subscription => subscription}
    #render text: html
  end

  def course_description
    # @favorite_courses = current_user.favorite_courses
    @course = Course.find_by_id(params[:id])
    if @course.present?
      @og = @course.og_all
      bunch_course = current_user.bunch_courses.where(course_id: @course.id).last rescue nil
      test_final = @course.test
      if test_final.present?
        test_final_result = (test_final.test_results.where(user_id: current_user.id).last) rescue true
        if bunch_course.present? && (bunch_course.full_complete? rescue false) && test_final_result.blank? && params[:attachment_id].present?
          redirect_to "/tests/#{test_final.id}/run"
        end
      end
      if @course.material? || @course.instrument?
        attachment = @course.attachments.last
        unless @course.instrument?
          unless (@course.find_bunch_course(current_user.id).present? rescue !attachment.public)
            redirect_to "/courses/material"
          else
            redirect_to attachment.present? ? "/attachment/#{attachment.id}" : "/"
          end
        else
          attachment = @course.attachments.where.not(full_text: '').last
          redirect_to attachment.present? ? "/instrument/#{attachment.id}" : '/courses/instrument'
        end
      end
    else
      page_404
    end
  end

  def group
    @members = current_user.company.users
    except_params = ["new", "no_group"]
    unless except_params.include?(params[:id])
      if current_user.director
        @group = (current_user.company.groups.find(params[:id]) rescue nil)
        redirect_to "/group/#{(current_user.company.groups.first.id rescue "new")}" unless @group.present?
      elsif current_user.corporate
        @group = (current_user.my_groups.find(params[:id]) rescue nil)
        redirect_to "/group/#{(current_user.my_groups.first.id rescue "no_group")}" unless @group.present?
      end
    end

  end

  def auth_user
    url_params = params.map { |k, v| [k.to_sym, CGI.unescape(v)] }.to_h
    session[:user_key] = params[:key] if User.where(user_key: params[:key]).present?
    redirect_url = url_params[:redirect].present? ? url_params[:redirect] : '/'
    render html: "<script>document.cookie = 'user_key=#{params[:key]}';window.location.href='#{redirect_url}';</script>".html_safe
  end

  def error_message(e)
    text = "<br/>#{e.message} -- #{e.class}<br/>#{e.backtrace.join("<br/>")}"

    HomeMailer.support_back(current_user, text).deliver
    render "common/page_500", :status => 500, :layout => "application"
  end

  def page_404
    render "common/page_404", :status => 404, :layout => "application"
  end

  def user
    @user = params[:user_id].present? ? User.find(params[:user_id]) : current_user
    @user_tests = Test.where(id: (@user.test_results.where(result: 100).map(&:test_id).uniq rescue []))
  end

  def course_cert
    @course = Course.find(params[:course_id]) rescue nil
    @params_png_id = params[:id]
    @user_cert_id = "#{params[:id]}.png"
    render :layout => false
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

  def subdomain
    @subdomain ||= $env_mode.subdomain(request)
    @subdomain
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
