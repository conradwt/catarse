class ProjectsMailer < ActionMailer::Base
  
  include ERB::Util
  
  default :from => "smartn.me <contact@smartn.me>"

  def new_project(about, rewards, links, contact, user, site)
    @about = h(about).gsub("\n", "<br>").html_safe
    @rewards = h(rewards).gsub("\n", "<br>").html_safe
    @links = h(links).gsub("\n", "<br>").html_safe
    @contact = contact
    @user = user
    @site = site
    attachments["rails.png"] = File.read("#{Rails.root}/public/assets/sites/smartn/logo.png")
    #mail(:to => "contact@smartn.me", :subject => t('projects_mailer.start_project_email.subject', :name => @user.name))
    mail(:to => "conradwt@gmail.com", :subject => t('projects_mailer.start_project_email.subject', :name => @user.name))
  end
  
end
