class UpdateCreateSites < ActiveRecord::Migration
  
  def self.up

    # Locate the site to edit.
    site = Site.find_by_name( 'SmartnMe' )

    # Dod we locate it?
    unless site.nil?
      site.facebook = 'http://www.facebook.com/pages/SmartNme/161820603885728'
      site.save
    end
    
  end

  def self.down
    
    # Locate the site to edit.
    site = Site.find_by_name( 'SmartnMe' )
    
    # Did we locate it?
    unless site.nil?
      site.facebook = 'TBD'
      site.save
    end
    
  end
  
end
