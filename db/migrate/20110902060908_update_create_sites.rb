class UpdateCreateSites < ActiveRecord::Migration
  
  def self.up

    site = Site.find_by_name( 'SmartnMe' )
    site.facebook = 'http://www.facebook.com/pages/SmartNme/161820603885728'
    site.save
    
  end

  def self.down
    
    site = Site.find_by_name( 'SmartnMe' )
    site.facebook = 'TBD'
    site.save
    
  end
  
end
