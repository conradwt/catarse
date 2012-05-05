class ProjectsMailer < MadMimiMailer
  
  include ERB::Util
  
  default :from => ENV['DEFAULT_EMAIL']

  def project_confirmation( user, project )
    @user = user
    @project = project
    @url = project_url( project )
    attachments["rails.png"] = File.read( "#{Rails.root}/public/assets/sites/smartn/logo.png" )

    mail( :to => "newcampaigns@smartn.me", :subject => t('projects_mailer.start_project_email.subject', :name => @user.name) )
  end
  
  def new_project_submission( user, project )
    subject         "#{ActionMailer::Base.default_url_options[:host]} - New Project Submission"
    # from            "newcampaigns@smartn.me"
    # recipients      "newcampaigns@smartn.me"
    from            "conradwt@gmail.com"
    recipients      "conradwt@gmail.com"

    body :full_name => user.name, :project_name => project.name, :project_url => project_url( project )
  end
  
  def update_project_submission( user, project )
    subject         "#{ActionMailer::Base.default_url_options[:host]} - Update Project Submission"
    # from            "newcampaigns@smartn.me"
    # recipients      "newcampaigns@smartn.me"
    from            "conradwt@gmail.com"
    recipients      "conradwt@gmail.com"

    body :full_name => user.name, :project_name => project.name, :project_url => project_url( project )
  end
  
end
