class AddSiteToBackers < ActiveRecord::Migration

  def self.up

    change_table :backers do |t|
      t.references :site, :null => false, :default => 1
    end

  end

  def self.down
    
    remove_column :backers, :site_id
    
  end
  
end
