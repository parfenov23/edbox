class DeliveryMailer < ActionMailer::Base
  default :from => "#{$env_mode.name_title} <support@adconsult.online>"

  def send_mail(email, title, description)
    @description = description
    @title = title
    mail(to: email, subject: title)
  end
end
