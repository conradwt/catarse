class ProjectsMailer < MadMimiMailer
  
  # include MadMimiMailable
  include ERB::Util
  # include Rails.application.routes.url_helpers
  
  default :from => ENV['DEFAULT_EMAIL']

  def project_confirmation( user, project )
    @user = user
    @project = project
    @url = project_url( project )
    attachments["rails.png"] = File.read( "#{Rails.root}/public/assets/sites/smartn/logo.png" )

    mail( :to => "newcampaigns@smartn.me", :subject => t('projects_mailer.start_project_email.subject', :name => @user.name) )
  end
  
  def new_project_submission( user, project )
    # subject "#{ActionMailer::Base.default_url_options[:host]} - New Project Submission"
    # # from        "newcampaigns@smartn.me"
    # # recipients  "newcampaigns@smartn.me"
    # from          "conradwt@gmail.com"
    # recipients    "conradwt@gmail.com"
    # 
    # body :full_name => user.name, :project_name => project.name, :project_url => project_url( project )
    
    options = { :promotion_name => 'new_project_submission', 
                :from           => "conradwt@gmail.com",
                :to             => "conradwt@gmail.com",
                :subject        => "#{ActionMailer::Base.default_url_options[:host]} - New Project Submission",
                :full_name      => user.name, 
                :project_name   => project.name, 
                :project_url    => "http://www.smartn.me/#{I18n.locale.to_s}/projects/#{self.to_param}" # project_url( project ) }

    mail( options )
  end
  
  def update_project_submission( user, project )
    # subject       "#{ActionMailer::Base.default_url_options[:host]} - Update Project Submission"
    # from        "newcampaigns@smartn.me"
    # recipients  "newcampaigns@smartn.me"
    # from          "conradwt@gmail.com"
    # recipients    "conradwt@gmail.com"
    
    # body :full_name => user.name, :project_name => project.name, :project_url => project_url( project )
    
    options = { :promotion_name => 'update_project_submission', 
                :from           => "conradwt@gmail.com",
                :to             => "conradwt@gmail.com",
                :subject        => "#{ActionMailer::Base.default_url_options[:host]} - Update Project Submission",
                :full_name      => user.name, 
                :project_name   => project.name, 
                :project_url    => "http://www.smartn.me/#{I18n.locale.to_s}/projects/#{self.to_param}" # project_url( project ) }
    
    mail( options )
  end
  
end
