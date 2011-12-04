class ProjectsMailer < ActionMailer::Base
  
  include ERB::Util
  
  default :from => "smartn.me <contact@smartn.me>"

  def new_project_email(about, rewards, links, contact, user, site)
    @about = h(about).gsub("\n", "<br>").html_safe
    @rewards = h(rewards).gsub("\n", "<br>").html_safe
    @links = h(links).gsub("\n", "<br>").html_safe
    @contact = contact
    @user = user
    @site = site
    #mail(:to => "contact@smartn.me", :subject => t('projects_mailer.start_project_email.subject', :name => @user.name))
    mail(:to => "conradwt@gmail.com", :subject => t('projects_mailer.start_project_email.subject', :name => @user.name))
  end
  
end
