class AddSiteToProjects < ActiveRecord::Migration

  def self.up

    change_table :projects do |t|
      t.references :site, :null => false, :default => 1
    end

  end

  def self.down
    
    remove_column :projects, :site_id
    
  end
  
end
