# encoding: utf-8
class HomeMailer < ActionMailer::Base
  default :from => 'Masshtab <info@masshtab.am>'
  # layout 'home_email', :except => [:order_product_user]

  def welcome_latter(user, new_password)
    @user = user
    @new_password = new_password
    mail(:to => @user.email, :subject => "Добро пожаловать в Edbox!")
  end

  def change_password(user, new_password)
    @user = user
    @new_password = new_password
    mail(:to => @user.email, :subject => "Ваш пароль изменился")
  end

end
