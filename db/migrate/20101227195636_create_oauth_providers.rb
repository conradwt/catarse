class CreateOauthProviders < ActiveRecord::Migration

  def self.up

    create_table :oauth_providers do |t|
      t.text :name, :null => false
      t.text :key, :null => false
      t.text :secret, :null => false
      t.text :scope
      t.integer :order
      t.timestamps
    end
    
  end

  def self.down
    
    drop_table :oauth_providers
    
  end
  
end

