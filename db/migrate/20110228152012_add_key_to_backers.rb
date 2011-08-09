class AddKeyToBackers < ActiveRecord::Migration

  def self.up
    
    add_column :backers, :key, :integer
    
    Backer.reset_column_information
    
    # TODO
    # execute( "UPDATE backers SET key = id" )
    
  end

  def self.down
    
    remove_column :backers, :key
    
  end
  
end
