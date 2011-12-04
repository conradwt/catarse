class UsersMailer < ActionMailer::Base

  default :from => "smartn.me <contact@smartn.me>"

  def project_confirmation(user)
    @user = user
    attachments["rails.png"] = File.read("#{Rails.root}/public/assets/sites/smartn/logo.png")

    mail( :to => "#{user.name} <#{user.email}>", :subject => "smartn.me - Thank you for creating a project")
  end

  def notification_email(notification)
    @notification = notification
    old_locale = I18n.locale
    I18n.locale = @notification.user.locale
    attachments["rails.png"] = File.read("#{Rails.root}/public/assets/sites/smartn/logo.png")

    mail( :to => "#{@notification.user.name} <#{@notification.user.email}>", :subject => @notification.email_subject )

    I18n.locale = old_locale
  end
  
end
