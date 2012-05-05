class ProjectsMailer < MadMimiMailer
  
  include ERB::Util
  
  default :from => ENV['DEFAULT_EMAIL']
  
  def new_project_submission( user, project )    
    body    = { :full_name      => user.name, 
                :project_name   => project.name, 
                :project_url    => "http://www.smartn.me/#{I18n.locale.to_s}/projects/#{self.to_param}" # project_url( project )
              }
         
    options = { :promotion_name => 'new_project_submission', 
                :from           => "conradwt@gmail.com",
                :to             => "conradwt@gmail.com",
                :subject        => "#{ActionMailer::Base.default_url_options[:host]} - New Project Submission",
                :body           => body.to_yaml
              }
           
            mail( options )
  end
  
  def update_project_submission( user, project )
    body    = { :full_name      => user.name, 
                :project_name   => project.name, 
                :project_url    => "http://www.smartn.me/#{I18n.locale.to_s}/projects/#{self.to_param}" # project_url( project ) }
              }
        
    options = { :promotion_name => 'update_project_submission', 
                :from           => "conradwt@gmail.com",
                :to             => "conradwt@gmail.com",
                :subject        => "#{ActionMailer::Base.default_url_options[:host]} - Update Project Submission",
                :body           => body.to_yaml
              }
    
    mail( options )
  end
  
end
