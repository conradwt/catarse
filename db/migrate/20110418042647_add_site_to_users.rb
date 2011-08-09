class AddSiteToUsers < ActiveRecord::Migration

  def self.up

    change_table :users do |t|
      t.references :site, :null => false, :default => 1
    end
    
  end

  def self.down
    
    remove_column :users, :site_id
    
  end
  
end
