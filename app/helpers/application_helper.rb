module ApplicationHelper
  
  def error_content_for( controller )
    
    content_for( :content_header ) do
      
      case controller.action_name
      when 'render_404_error' 
        raw( content_tag( :h1, '404:  Page Not Found' ) )
      when 'errship_standard'
        raw( content_tag( :h1, '500:  Server Error' ) )
      else
        raw( content_tag( :h1, 'Add Title') +
             content_tag( :h2, 'Add Subtitle' )
           )
       end
    
    end
        
  end
  
end