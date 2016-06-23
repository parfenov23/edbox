# encoding: utf-8
class HomeMailer < ActionMailer::Base
  include ApplicationHelper
  helper_method :domain

  default :from => "#{$env_mode.name_title} <info@masshtab.am>"
  # layout 'home_email', :except => [:order_product_user]

  def welcome_latter(user, new_password)
    @user = user
    @new_password = new_password
    mail(:to => @user.email, :subject => "Добро пожаловать в #{$env_mode.name_title}!")
  end

  def email_notifs(email, user)
    @user = user
    mail(:to => email, :subject => "Регистрация в #{$env_mode.name_title}!")
  end

  def sendRequest(params)
    @params = params
    mail(:to => 'bazhan@masshtab.am, leads@romanpivovarov.ru, leads@adconsult.club, roman.pivovarov@gmail.com', :subject => "Заявка с Edbox", :reply_to => @params[:email])
  end

  def change_password(user, new_password)
    @user = user
    @new_password = new_password
    mail(:to => @user.email, :subject => "Ваш пароль изменился")
  end

  def notice_letter(email, course)
    @email = email
    @user = User.find_by_email(email)
    @course = course
    mail(:to => @email, :subject => "В #{$env_mode.name_title} вышел курс, который вы ждали")
  end

  def notice_confirm(email, course)
    @email = email
    @course = course
    @user = User.find_by_email(email)
    mail(:to => @email, :subject => "Вы подписались на обновления #{$env_mode.name_title}")
  end

  def reg_webinar(webinar, user)
    @webinar = webinar
    @attachment = @webinar.attachment
    @user = user
    @date_start = (@webinar.date_start + User.time_zone.hour)

    mail(:to => @user.email, :subject => "Вы зарегистрировались на вебинар #{@attachment.title}")
  end

  def reg_course(course, user)
    @course = course
    @user = user

    mail(:to => @user.email, :subject => "Вы подписаны на курс #{@course.title}")
  end

  def order_bill(params, user)
    @params = params
    @user = user
    mail(:to => 'supportadonline@adconsult.ru', :subject => "Заявка на выставление счета")
  end

  def reg_course_director(course, user, bunch_course)
    @course = course
    @user = user
    @bunch_course = bunch_course
    mail(:to => @user.email, :subject => "Директор подписал вас на курс #{@course.title}")
  end

  def reg_webinar_lead(webinar, user)
    @webinar = webinar
    @attachment = @webinar.attachment
    @user = user
    date_start = (@webinar.date_start + User.time_zone.hour)
    @date_start = "#{parse_russian_date(date_start)} (по Мск)"

    mail(:to => @user.email, :subject => "Вы назначены ведущим вебинара #{@attachment.title}")
  end

  def unreg_webinar(webinar, user)
    @webinar = webinar
    @attachment = @webinar.attachment
    @user = user

    mail(:to => @user.email, :subject => "Вы отменили регистрацию на вебинар #{@attachment.title}")
  end

  def soon_began_webinar(user, webinar)
    @webinar = webinar
    @attachment = @webinar.attachment
    @user = user

    mail(:to => @user.email, :subject => "Через 15 минут начнется вебинар #{@attachment.title}")
  end

  def support_back(user, text)
    @email = user.email rescue nil
    @error = text
    mail(:to => 'parfenov407@gmail.com', :subject => "Ошибка в системе #{$env_mode.name_title}")
  end

  private

  def domain
    @domain ||= current_domain(5000)
    @domain
  end

end
