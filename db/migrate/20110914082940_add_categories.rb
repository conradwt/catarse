class AddCategories < ActiveRecord::Migration
  
  def self.up
    
    # Add some educational categories.
    [ 'High School', 'Undergraduate', 'Graduate' ].each do | category |
      Category.create!( :name => category )
    end
      
  end

  def self.down
    
    # Remove all the records.
    Category.destroy_all
    
  end
  
end
