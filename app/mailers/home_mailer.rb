# encoding: utf-8
class HomeMailer < ActionMailer::Base
  default :from => 'Masshtab <info@masshtab.am>'
  # layout 'home_email', :except => [:order_product_user]

  def welcome_latter(user)
    @user = user
    mail(:to => @user.email, :subject => "Добро пожаловать в Edbox!")
  end
end
