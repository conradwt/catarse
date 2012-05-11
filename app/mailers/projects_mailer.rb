class ProjectsMailer < MadMimiMailer
  
  include ERB::Util
  
  default :from => ENV['DEFAULT_EMAIL']
  
  def new_project_submission( user, project )    
    body    = { :full_name      => user.name, 
                :project_name   => project.name, 
                :project_url    => project_url( project )
              }
         
    options = { :promotion_name => 'new_project_submission', 
                :recipients     => "smartn.me team <newcampaigns@smartn.me>",
                :from           => "smartn.me team <newcampaigns@smartn.me>",
                :subject        => "#{ActionMailer::Base.default_url_options[:host]} - New Project Submission"
              }

    mimi = MadMimi.new( ENV['MADMIMI_USERNAME'], ENV['MADMIMI_API_KEY'] )
    mimi.send_mail( options, body )
  end
  
  def update_project_submission( user, project )
    body    = { :full_name      => user.name, 
                :project_name   => project.name, 
                :project_url    => project_url( project )
              }
        
    options = { :promotion_name => 'update_project_submission', 
                :recipients     => "smartn.me team <newcampaigns@smartn.me>",
                :from           => "smartn.me team <newcampaigns@smartn.me>",
                :subject        => "#{ActionMailer::Base.default_url_options[:host]} - Update Project Submission"
              }
    
    mimi = MadMimi.new( ENV['MADMIMI_USERNAME'], ENV['MADMIMI_API_KEY'] )
    mimi.send_mail( options, body )
  end
  
end
