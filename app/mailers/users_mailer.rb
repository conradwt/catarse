class UsersMailer < MadMimiMailer

  default :from => ENV['DEFAULT_EMAIL']

  def project_confirmation( user, project )
    @user = user
    @project = project
    attachments["rails.png"] = File.read("#{Rails.root}/public/assets/sites/smartn/logo.png")

    mail( :to => "#{user.name} <#{user.email}>", :subject => "#{ActionMailer::Base.default_url_options[:host]} - Thank you for creating a project")
  end
  
  def new_project_confirmation( user, project )
    subject         "#{ActionMailer::Base.default_url_options[:host]} - Thank you for submitting your project"
    from            "newcampaign@smartn.me" 
    recipients      user.email

    body :full_name => user.name, :project_name => project.name
  end
  
  def update_project_confirmation( user, project )
    subject         "#{ActionMailer::Base.default_url_options[:host]} - Thank you for updating your project"
    from            "newcampaign@smartn.me" 
    recipients      user.email

    body :full_name => user.name, :project_name => project.name
  end

  def notification_email( notification )
    @notification = notification
    old_locale = I18n.locale
    I18n.locale = @notification.user.locale
    attachments["rails.png"] = File.read("#{Rails.root}/public/assets/sites/smartn/logo.png")

    mail( :to => "#{@notification.user.name} <#{@notification.user.email}>", :subject => @notification.email_subject )

    I18n.locale = old_locale
  end
  
end
