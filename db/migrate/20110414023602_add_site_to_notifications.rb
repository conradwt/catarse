class AddSiteToNotifications < ActiveRecord::Migration

  def self.up

    change_table :notifications do |t|
      t.references :site, :null => false, :default => 1
    end

  end

  def self.down
    
    remove_column :notifications, :site_id
    
  end
  
end
