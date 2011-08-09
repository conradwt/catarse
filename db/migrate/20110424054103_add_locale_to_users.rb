class AddLocaleToUsers < ActiveRecord::Migration

  def self.up
    
    add_column :users, :locale, :string, :null => false, :default => 'en'
    
  end

  def self.down
    
    remove_column :users, :locale
    
  end
  
end
