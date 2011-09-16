class AddCategories < ActiveRecord::Migration
  
  def self.up
    
    [ 'Undergraduate Studies', 
      'Graduate Studies', 
      'Post Graduate Studies', 
      'Professional Studies', 
      'Independent Studies', 
      'Language & Cultural Studies',
      'Volunteering', 
      'Other'
    ].each { | category | Category.create!( :name => category ) }
      
  end

  def self.down
    
    # Remove all the records.
    Category.destroy_all
    
  end
  
end
