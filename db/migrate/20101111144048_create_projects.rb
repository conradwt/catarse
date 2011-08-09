class CreateProjects < ActiveRecord::Migration

  def self.up
    
    create_table :projects do |t|
      t.string :name, :null => false
      t.references :user, :null => false
      t.references :category, :null => false
      t.decimal :goal, :null => false
      t.datetime :expires_at, :null => false
      t.text :about, :null => false
      t.text :headline, :null => false
      t.text :video_url, :null => false
      t.text :image_url
      t.text :short_url
      t.boolean :visible, :default => false
      t.boolean :rejected, :default => false
      t.boolean :recommended, :default => false
      t.timestamps
    end
    
    add_index :projects, :user_id
    add_index :projects, :category_id
    add_index :projects, :name
    
  end
  
  def self.down
    
    drop_table :projects
    
  end
  
end

