# encoding: utf-8
class HomeMailer < ActionMailer::Base
  include ApplicationHelper
  helper_method :domain
  default :from => 'ADCONSULT ONLINE <info@masshtab.am>'
  # layout 'home_email', :except => [:order_product_user]

  def welcome_latter(user, new_password)
    @user = user
    @new_password = new_password
    mail(:to => @user.email, :subject => "Добро пожаловать в ADCONSULT ONLINE!")
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
    @course = course
    mail(:to => @email, :subject => 'В Edbox вышел курс, который вы ждали')
  end

  def notice_confirm(email, course)
    @email = email
    @course = course
    mail(:to => @email, :subject => 'Вы подписались на обновления Edbox ADCONSULT')
  end

  def reg_webinar(webinar, user)
    @webinar = webinar
    @attachment = @webinar.attachment
    @user = user
    date_start = (@webinar.date_start + User.time_zone.hour)
    @date_start = "#{parse_russian_date(date_start)} (по Мск)"

    mail(:to => @user.email, :subject => "Вы зарегистрировались на вебинар #{@attachment.title}")
  end

  def unreg_webinar(webinar, user)
    @webinar = webinar
    @attachment = @webinar.attachment
    @user = user

    mail(:to => @user.email, :subject => "Вы отменили регистрацию на вебинар #{@attachment.title}")
  end

  private

  def domain
    @domain ||= current_domain(5000)
    @domain
  end

end
