class CreateNotifications < ActiveRecord::Migration

  def self.up

    create_table :notifications do |t|
      t.references :user, :null => false
      t.references :project
      t.text :text, :null => false
      t.text :twitter_text
      t.text :facebook_text
      t.text :email_subject
      t.text :email_text
      t.boolean :dismissed, :null => false, :default => false
      t.timestamps
    end
    
  end
  
  def self.down
    
    drop_table :notifications
    
  end
  
end
