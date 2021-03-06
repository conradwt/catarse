class CreateUsers < ActiveRecord::Migration
  
  def self.up
    
    create_table :users do |t|
      t.integer :primary_user_id
      t.text    :provider, :null => false
      t.string  :uid, :null => false
      t.string  :email
      t.string  :name
      t.text    :nickname
      t.text    :bio
      t.text    :image_url
      t.boolean :newsletter, :default => false
      t.boolean :project_updates, :default => false
      t.timestamps
    end

    add_index :users, :uid
    add_index :users, :name
    add_index :users, :email
    
  end
  
  def self.down
    
    drop_table :users
    
  end
  
end
