class DeliveryMailer < ActionMailer::Base
  default :from => "#{$env_mode.name_title} <info@masshtab.am>"

  def send_mail(email, title, description)
    @description = description
    mail(to: email, subject: title)
  end
end
